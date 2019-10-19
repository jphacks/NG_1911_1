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
        
    }
    
    func toRideView() {
        
    }
}

extension HomePresenter: ApiModelDelegate {
    func didGetApi() {
        print("good!")
    }
}
