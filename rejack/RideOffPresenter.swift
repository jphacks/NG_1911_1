//
//  RideOffPresenter.swift
//  rejack
//
//  Created by 梶原大進 on 2019/10/19.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import Foundation

class RideOffPresenter {
    let apiModel: ApiModel
    
    weak var view: RideOffViewInterface?
    
    init(with view: RideOffViewInterface) {
        self.view = view
        self.apiModel = ApiModel()
        
        apiModel.delegate = self
    }
}

extension RideOffPresenter: ApiModelDelegate {
    func didGetApi() {
        
    }
}
