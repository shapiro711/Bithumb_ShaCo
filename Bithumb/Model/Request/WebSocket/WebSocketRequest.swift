//
//  WebSocketRequest.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/19.
//

import Foundation

enum WebSocketType {
    case bitumbPublic
    
    var path: String {
        return "/pub"
    }
    
    var specificPath: String {
        return "/ws"
    }
}

enum MessageType {
    case ticker(symbols: [String], tickTypes: [CriteriaOfChange] = [.yesterdayMidnight])
    case transaction(symbols: [String])
    case orderBookDepth(symbols: [String])
}

enum WebSocketRequest {
    case connect(target: WebSocketType)
    case disconnect
    case send(message: MessageType)
}


