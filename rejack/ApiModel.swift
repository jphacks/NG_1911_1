//
//  ApiModel.swift
//  rejack
//
//  Created by 梶原大進 on 2019/11/01.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

struct Test: Codable {
    let hello: String
}

protocol ApiModelDelegate {
    func didGetApi()
    func didKeyOpen()
    func didStartAlert()
    func didStopAlert()
}

class ApiModel {
    var url = ApiUrl.shared.baseUrl
    
    var delegate: ApiModelDelegate?
    
    func get_request(endpoint: String) -> Bool {
        Alamofire.request(url + "/api/key" + endpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else { return }
            print(data)
        }
        return true
    }
    
    func unlockKey() {
        if get_request(endpoint: "open") {
            self.delegate?.didKeyOpen()
        } else {
            print("エラー")
        }
//        Alamofire.request(url + "/api/key/open", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
//            guard let data = response.data else {
//                return
//            }
//            print(data)
//            self.delegate?.didKeyOpen()
//        }
    }
    
    func lockKey() {
        if !get_request(endpoint: "close") {
            print("エラー")
        }
//        Alamofire.request(url + "/api/key/close", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
//            guard let data = response.data else {
//                return
//            }
//            print(data)
//        }
    }
    
    func startAlert() {
        if !get_request(endpoint: "close") {
            print("エラー")
        }
//        Alamofire.request(url + "/api/alert/start", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
//            guard let data = response.data else {
//                return
//            }
//            print(data)
//        }
    }
    
    func stopAlert() {
        if !get_request(endpoint: "close") {
            print("エラー")
        }
//        Alamofire.request(url + "/api/alert/stop", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
//            guard let data = response.data else {
//                return
//            }
//            print(data)
//        }
    }
}
