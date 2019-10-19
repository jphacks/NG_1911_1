//
//  ApiModel.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Test: Codable {
    let hello: String
}

protocol ApiModelDelegate {
    func didGetApi()
}

class ApiModel {
    var url = ApiUrl.shared.baseUrl
    
    var delegate: ApiModelDelegate?
    
    func test() {
        print("test")
//        Alamofire.request(url + "/api/key/open", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
//            guard let data = response.data else {
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let test: Test = try decoder.decode(Test.self, from: data)
//                print(test)
//                self.delegate?.didGetApi()
//            } catch {
//                print(error)
//            }
//        }
    }
}
