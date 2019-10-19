//
//  RideOnViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import CoreMotion

protocol RideOnViewInterface: class {
    
}

class RideOnViewController: UIViewController, RideOnViewInterface {
    var presenter: RideOnPresenter!
    var motionMg: CMMotionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RideOnPresenter(with: view as! RideOnViewInterface)
        
        motionMg.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            print(data?.acceleration.x as Any)
            print(data?.acceleration.y as Any)
            print(data?.acceleration.z as Any)
            if (Int((data?.acceleration.x)!) < 1 && Int((data?.acceleration.y)!) < 1) {
                self.showButton()
            }
        })
    }
    
    func startAlert() {
        presenter.startAlert()
    }
    
    func showAlert() {
        
    }
    
    func showButton() {
        
    }
    
    @IBAction func rideOff() {
        //画面遷移
        
    }
}
