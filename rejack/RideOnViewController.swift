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
import AVFoundation

class RideOnViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var rideOffBtn: UIButton!
    @IBOutlet var warningImageView: UIImageView!
    
    var locationMg: CLLocationManager!
    
    var pre_lat = 0.0
    var pre_lon = 0.0
    var loc_counter: Int = 0
    
    var routes: [Route]?
    var current_route_index = 1
    var needNavigation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if needNavigation {
            let text = "案内を開始します"
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            sleep(2)
            
            let first_navi = routes![0].instructions
            let talker2 = AVSpeechSynthesizer()
            let utterance2 = AVSpeechUtterance(string: first_navi)
            utterance2.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker2.speak(utterance2)
            sleep(2)
        }

        if CLLocationManager.locationServicesEnabled() {
            locationMg = CLLocationManager()
            locationMg.delegate = self
            locationMg.startUpdatingLocation()
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running.png")!)
        
        self.rideOffBtn.isEnabled = false
        self.warningImageView.alpha = 0
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
        
        print("lat: ", lat)
        print("lon: ", lon)
        print("pre_lat", pre_lat)
        print("pre_lon", pre_lon)
        
        if round(lat*pow(10, 7)) == round(pre_lat*pow(10, 7))
            && round(lon*pow(10, 7)) == round(pre_lon*pow(10, 7)) {
            loc_counter += 1
            print(loc_counter)
            if loc_counter >= 1 {
                self.showButton()
            }
        } else {
            loc_counter = 0
            print(loc_counter)
            if loc_counter < 1 {
                self.hideButton()
            }
        }
        
        pre_lon = location.coordinate.longitude
        pre_lat = location.coordinate.latitude
        
        if needNavigation {
            if current_route_index < (routes?.count)! {
                if round(routes![current_route_index].lat*pow(10, 3)) ==  round(location.coordinate.latitude*pow(10, 3))
                    && round(routes![current_route_index].lng*pow(10, 3)) == round(location.coordinate.longitude*pow(10, 3))
                {
                    self.locationMg.stopUpdatingHeading()
                    let text = routes![current_route_index].instructions
                    let talker = AVSpeechSynthesizer()
                    let utterance = AVSpeechUtterance(string: text)
                    utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                    talker.speak(utterance)
                    current_route_index += 1
                    sleep(2)
                }
            }
        }
    }
    
    func showButton() {
        self.rideOffBtn.isEnabled = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stop.png")!)
    }
    
    func hideButton() {
        self.rideOffBtn.isEnabled = false
    }
    
    @IBAction func rideOffAC(_ sender: UIButton) {
        doRide = false
        self.locationMg.stopUpdatingLocation()
    }
}
