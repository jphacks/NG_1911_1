//
//  RideOffViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RideOffViewController: UIViewController {
    var url = ApiUrl.shared.baseUrl

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func rideOff() {
        Alamofire.request(url + "/api/key/close", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            print(data)
        }
    }

}
