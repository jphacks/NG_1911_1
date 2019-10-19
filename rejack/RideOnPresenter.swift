//
//  RideOnPresenter.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class RideOnPresenter {
    let apiModel: ApiModel
    
    weak var view: RideOnViewInterface?
    
    init(with view: RideOnViewInterface) {
        self.view = view
        self.apiModel = ApiModel()
        
        apiModel.delegate = self
    }
    
    func startAlert() {
        apiModel.startAlert()
    }
}

extension RideOnPresenter: ApiModelDelegate {
    func didStartAlert() {
    }
    
    func didStopAlert() {
    }
    
    func didKeyOpen() {
    }
    
    func didGetApi() {
        print("good!")
    }
}
