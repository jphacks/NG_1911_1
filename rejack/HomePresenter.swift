//
//  HomePresenter.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class HomePresenter {
    let apiModel: ApiModel
    
    weak var view: HomeViewInterface?
    
    init(with view: HomeViewInterface) {
        self.view = view
        self.apiModel = ApiModel()
        
        apiModel.delegate = self
    }
    
    func test() {
        apiModel.test()
    }
    
    func unlockKey() {
        apiModel.unlockKey()
    }
    
    func toRideView() {
        view?.toRideView()
    }
}

extension HomePresenter: ApiModelDelegate {
    func didStartAlert() {
        
    }
    
    func didStopAlert() {
        
    }
    
    func didGetApi() {
        print("good!")
    }
    
    func didKeyOpen() {
        self.toRideView()
    }
}
