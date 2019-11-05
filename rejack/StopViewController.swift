//
//  StopViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/11/05.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit

class StopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func restart() {
        self.dismiss(animated: true, completion: nil)
    }

}
