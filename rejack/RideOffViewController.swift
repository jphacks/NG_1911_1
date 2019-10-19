//
//  RideOffViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit

protocol RideOffViewInterface: class {
    
}

class RideOffViewController: UIViewController, RideOffViewInterface {
    var presenter: RideOffPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RideOffPresenter(with: view as! RideOffViewInterface)
    }
    
    func lockKey() {
        presenter.lockLey()
    }

}
