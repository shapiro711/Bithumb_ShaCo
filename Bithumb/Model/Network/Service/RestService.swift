//
//  RestService.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct RestService: Serviceable {
    var networkConfigure: NetworkConfigurable
    
    init(networkConfigure: NetworkConfigurable = RestConfigure()) {
        self.networkConfigure = networkConfigure
    }
}
