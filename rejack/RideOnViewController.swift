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
    
}

class RideOnViewController: UIViewController, RideOnViewInterface, CLLocationManagerDelegate {
    @IBOutlet var rideOffBtn: UIButton!
    @IBOutlet var warningImageView: UIImageView!
    
    var locationMg: CLLocationManager!
    var presenter: RideOnPresenter!
    
    var pre_lat = 0.0
    var pre_lon = 0.0
    var loc_counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running.png")!)
        
        self.rideOffBtn.isEnabled = false
        self.warningImageView.alpha = 0
        
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
        guard let location = locations.last,
            CLLocationCoordinate2DIsValid(location.coordinate) else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
//        print("lat: ", lat)
//        print("lon: ", lon)
//        print("pre_lat", pre_lat)
//        print("pre_lon", pre_lon)
        
        if round(lat*10000000000)/10000000000 == round(pre_lat*10000000000)/10000000000
            && round(lon*10000000000)/10000000000 == round(pre_lon*10000000000)/10000000000 {
            loc_counter += 1
            print(loc_counter)
            if loc_counter > 5 {
                self.showButton()
                //self.locationMg.stopUpdatingLocation()
            }
        } else {
            loc_counter -= 1
            print(loc_counter)
            if loc_counter <= 5 {
                self.hideButton()
            }
        }
        
        pre_lon = location.coordinate.longitude
        pre_lat = location.coordinate.latitude
    }
    
    func startAlert() {
        presenter.startAlert()
    }
    
    func showAlert() {
        
    }
    
    func showButton() {
        self.rideOffBtn.isEnabled = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stop.png")!)
    }
    
    func hideButton() {
        self.rideOffBtn.isEnabled = false
    }
    
}
