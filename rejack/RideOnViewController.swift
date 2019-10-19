//
//  RideOnViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit

protocol RideOnViewInterface: class {
    
}

class RideOnViewController: UIViewController, RideOnViewInterface {
    var presenter: RideOnPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RideOnPresenter(with: view as! RideOnViewInterface)
    }

}
