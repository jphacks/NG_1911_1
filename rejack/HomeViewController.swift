//
//  HomeViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreNFC
import CoreMotion
import CoreLocation

struct Route: Codable {
    var lat: Double
    var lng: Double
    var instructions: String
}

protocol HomeViewInterface: class {
    func toRideView()
}

class HomeViewController: UIViewController, HomeViewInterface, NFCNDEFReaderSessionDelegate, CLLocationManagerDelegate {
    var presenter: HomePresenter!
    var url = ApiUrl.shared.baseUrl
    
    var routes: [Route]?
    var locationMg: CLLocationManager!
    var lat: Double = 0.0
    var lon: Double = 0.0
    var needNavigation:  Bool = false
    
    var session: NFCNDEFReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationMg = CLLocationManager()
            locationMg.delegate = self
            if #available(iOS 9.0, *) {
                self.locationMg.requestLocation() // 一度きりの取得
            }
        }

        presenter = HomePresenter(with: self)

        presenter?.test()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rideOn" {
            let rideon = segue.destination as! RideOnViewController
            //rideon.routes = self.routes
            rideon.needNavigation = self.needNavigation
        } else if segue.identifier == "toSetNavi" {
            let toSetNavi = segue.destination as! SetNavigationViewController
            toSetNavi.routes = self.routes
            toSetNavi.needNavigation = self.needNavigation
            toSetNavi.lat = self.lat
            toSetNavi.lon = self.lon
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        self.unlockKey()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("位置情報取得")
        lat = locations[0].coordinate.latitude
        lon = locations[0].coordinate.longitude
        manager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
    
    func unlockKey() {
        presenter.unlockKey()
    }
    
    func toRideView() {
        print("toRide")
        let alert: UIAlertController = UIAlertController(title: "確認", message: "道案内を利用しますか？", preferredStyle: UIAlertController.Style.alert)
        let notUseMap: UIAlertAction = UIAlertAction(title: "利用しない", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "rideOn", sender: nil)
        })
        let useMap = UIAlertAction(title: "利用する", style: .default, handler: {[weak alert] (action) -> Void in
//            guard let textField = alert?.textFields else {
//                return
//            }
//            guard !textField.isEmpty else {
//                return
//            }
//            let destination = textField[0].text!
//            let urlString: String = self.url + "/api/route?origin=\(String(self.lat)),\(String(self.lon))&destination=\(destination)"
//            let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            Alamofire.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
//                guard let data = response.data else { return }
//                let decoder  = JSONDecoder()
//                do {
//                    let routes: [Route] = try decoder.decode([Route].self, from: data)
//                    self.routes = routes
//                    print(routes)
//                    self.needNavigation = true
//                    self.locationMg.stopUpdatingHeading()
//                    self.performSegue(withIdentifier: "rideOn", sender: nil)
//                } catch {
//                    print(error)
//                }
//            }
            self.performSegue(withIdentifier: "toSetNavi", sender: nil)
        })
        
//        let APIKEY = KeyManager().getValue(key: "apikey") as? String
//        let urlstr: String = "https://maps.google.com/maps/api/staticmap?center=名古屋大学&markers=color:blue%7C名古屋大学&size=600x400&zoom=15&key=" + APIKEY!
//        let encodeUrlstr: String = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let url = URL(string: encodeUrlstr)
//        do {
//            let data = try Data(contentsOf: url!)
//            let image = UIImage(data: data)
//            let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
//            imgViewTitle.image = image
//            alert.view.addSubview(imgViewTitle)
//        }catch let err {
//            print("Error : \(err.localizedDescription)")
//        }
        
        alert.addAction(notUseMap)
        alert.addAction(useMap)
        //alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func readNFC(_ sender: UIButton) {
        //Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.timerUpdate), userInfo: nil, repeats: true)
        self.unlockKey()
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "スキャンできません",
                message: "このデバイスやと無理ですよ",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //self.present(alertController, animated: true, completion: nil)
            return
        }

        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "カードを近づけてーー"
        session?.begin()
    }
}

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
