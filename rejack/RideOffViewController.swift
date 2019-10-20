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

protocol RideOffViewInterface: class {
    
}

class RideOffViewController: UIViewController, RideOffViewInterface {
    var presenter: RideOffPresenter!
    var url = ApiUrl.shared.baseUrl

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func lockKey() {
        presenter.lockLey()
    }
    
    @IBAction func rideOff() {
        //self.lockKey()
        Alamofire.request(url + "/api/key/close", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            print(data)
        }
    }

}
