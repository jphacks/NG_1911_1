//
//  RideOnViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

protocol RideOnViewInterface: class {
    func toRideOff()
}

class RideOnViewController: UIViewController, RideOnViewInterface, CLLocationManagerDelegate {
    @IBOutlet var rideOffBtn: UIButton!
    
    var locationMg: CLLocationManager!
    var presenter: RideOnPresenter!
    
    var pre_lat = 0.0
    var pre_lon = 0.0
    var loc_counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rideOffBtn.alpha = 0
        
        //presenter = RideOnPresenter(with: view as! RideOnViewInterface)
        
        if CLLocationManager.locationServicesEnabled() {
            locationMg = CLLocationManager()
            locationMg.delegate = self as CLLocationManagerDelegate
            locationMg.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationMg.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude)")
        }
        
        
    }
    
    func startAlert() {
        presenter.startAlert()
    }
    
    func showAlert() {
        
    }
    
    func showButton() {
        self.rideOffBtn.alpha = 1
    }
    
    func toRideOff() {
        
    }
    
}
