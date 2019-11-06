//
//  SetNavigationViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/20.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SetNavigationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var serchBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    @IBOutlet var destination: UIImageView!
    @IBOutlet var textView: UITextField!
    @IBOutlet var destinationLabel: UILabel!
    
    var lat = 0.0
    var lon = 0.0
    var url = ApiUrl.shared.baseUrl
    var routes: [Route]?
    var needNavigation: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRideOnWithNavi" {
            let rideOn = segue.destination as! RideOnViewController
            rideOn.routes = self.routes
            rideOn.needNavigation = self.needNavigation
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func serchAC() {
        let destination = textView.text!
        
        textView.endEditing(true)
        
        let APIKEY = KeyManager().getValue(key: "apikey") as? String
        let urlstr: String = "https://maps.google.com/maps/api/staticmap?center=\(String(destination))&markers=size:mid|color:red|label:A|\(String(destination))&size=600x400&zoom=15&key=" + APIKEY!
        let encodeUrlstr: String = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodeUrlstr)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            self.destination.image = image
            self.destinationLabel.text = destination
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
    }
    
    @IBAction func settingAC() {
        let destination = textView.text!
        let urlString: String = self.url + "/api/route?origin=\(String(self.lat)),\(String(self.lon))&destination=\(destination)"
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else { return }
            let decoder  = JSONDecoder()
            do {
                let routes: [Route] = try decoder.decode([Route].self, from: data)
                self.routes = routes
                print(routes)
                self.needNavigation = true
                doRide = true
                self.performSegue(withIdentifier: "toRideOnWithNavi", sender: nil)
            } catch {
                print(error)
            }
        }
    }

}
