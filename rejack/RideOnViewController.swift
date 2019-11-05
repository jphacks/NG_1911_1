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
    @IBOutlet var lockOnlyBtn: UIButton!
    @IBOutlet var lockBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running.png")!)
        
        searchBtn.isEnabled = false
        rideOffBtn.isEnabled = false
        rideOffBtn.alpha = 1
        lockOnlyBtn.alpha = 0
        lockBtn.alpha = 0
        
        locationMg.startUpdatingLocation()
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
        searchBtn.isEnabled = true
        rideOffBtn.isEnabled = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stop.png")!)
    }
    
    func hideButton() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "running.png")!)
        searchBtn.isEnabled = false
        rideOffBtn.isEnabled = false
        rideOffBtn.alpha = 1
        lockOnlyBtn.alpha = 0
        lockBtn.alpha = 0
    }
    
    @IBAction func rideOffAC(_ sender: UIButton) {
        rideOffBtn.alpha = 0
        lockOnlyBtn.alpha = 1
        lockBtn.alpha = 1
        doRide = false
    }
    
    @IBAction func lockOnlyAC(_ sender: UIButton) {
        //位置情報の更新を止める
        self.locationMg.stopUpdatingLocation()
    }
    
    @IBAction func lockAC(_ sender: UIButton) {
        // 位置情報の更新を止める
        self.locationMg.stopUpdatingLocation()
    }
    
    @IBAction func searchAC(_ sender: UIButton) {
        self.locationMg.stopUpdatingLocation()
    }
    
}
