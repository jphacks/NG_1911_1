//
//  HomeViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreNFC

protocol HomeViewInterface: class {
    
}

class HomeViewController: UIViewController, HomeViewInterface, NFCNDEFReaderSessionDelegate {
    var presenter: HomePresenter!
    var url = ApiUrl.shared.baseUrl
    
    var session: NFCNDEFReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = HomePresenter(with: self as! HomeViewInterface)

        presenter?.test()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        self.unlockKey()
    }
    
    func unlockKey() {
        self.unlockKey()
    }
    
    func toRideView() {
        
    }
    
    @IBAction func readNFC(_ sender: UIButton) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "スキャンできません",
                message: "このデバイスやと無理ですよ",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "カードを近づけてーー"
        session?.begin()
    }

}
