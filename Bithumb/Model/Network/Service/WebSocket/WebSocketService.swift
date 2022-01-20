//
//  WebSocketService.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct WebSocketService: Serviceable {
    var networkConfigure: NetworkConfigurable
    
    init(networkConfigure: NetworkConfigurable = WebSocketConfigure()) {
        self.networkConfigure = networkConfigure
    }
}
