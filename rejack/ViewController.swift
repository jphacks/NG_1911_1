//
//  ViewController.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/18.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                print(String(data: record.payload, encoding: .utf8)!)
            }
        }
    }
    
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func readNFC(_ sender: UIButton) {
        print("button pushed!!")
        
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

