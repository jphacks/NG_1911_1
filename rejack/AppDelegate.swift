//
//  AppDelegate.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/18.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isAgain: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Alamofire.request(ApiUrl.shared.baseUrl + "/api/alert/start", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            guard let data = response.data else {
                return
            }
            self.isAgain = true
            print(data)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if self.isAgain {
            Alamofire.request(ApiUrl.shared.baseUrl + "/api/alert/stop", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
                guard let data = response.data else {
                    return
                }
                self.isAgain = false
                print(data)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

class ApiUrl {
    var baseUrl: String = "http://ec2-13-114-103-68.ap-northeast-1.compute.amazonaws.coma"
    static let shared = ApiUrl()
    
    private init() {}
}

