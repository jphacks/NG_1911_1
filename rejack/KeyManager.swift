//
//  KeyManager.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/20.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

struct KeyManager {
    private let keyFilePath = Bundle.main.path(forResource: "apikey", ofType: "plist")
    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }
    
    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
