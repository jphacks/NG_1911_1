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

var doRide: Bool = false

class HomeViewController: UIViewController, NFCNDEFReaderSessionDelegate, CLLocationManagerDelegate {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rideOn" {
            let rideon = segue.destination as! RideOnViewController
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
        print(error)
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
        Alamofire.request(url + "/api/key/open", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            print(data)
            self.toRideView()
        }
    }
    
    func toRideView() {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "道案内を利用しますか？", preferredStyle: UIAlertController.Style.alert)
        let notUseMap: UIAlertAction = UIAlertAction(title: "利用しない", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            doRide = true
            self.performSegue(withIdentifier: "rideOn", sender: nil)
            
        })
        let useMap = UIAlertAction(title: "利用する", style: .default, handler: {[weak alert] (action) -> Void in
            self.performSegue(withIdentifier: "toSetNavi", sender: nil)
        })
        
        alert.addAction(notUseMap)
        alert.addAction(useMap)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func readNFC(_ sender: UIButton) {
        self.unlockKey()
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "スキャンできません",
                message: "このデバイスやと無理ですよ",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
