//
//  Test.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum RequestType {
    case ticker
    case orderbook
}

enum NetworkProtocolType {
    case rest
    case websocket
}

protocol Requestable {
    var requestType: RequestType { get }
    var networkProtocolType: NetworkProtocolType { get }
    var parameter: [String: Any]? { get } // 이게 조금 애매함
}

enum TickerAPI: Requestable {
    case lookUpAllTicker
    case lookUpSpecificTicker(order: String, payment: String)
    case subscribeTiker(symbol: [String])
    
    var requestType: RequestType {
        switch self {
        case .lookUpAllTicker:
            return RequestType.ticker
        case .lookUpSpecificTicker:
            return RequestType.ticker
        case .subscribeTiker:
            return RequestType.ticker
        }
    }
    
    var networkProtocolType: NetworkProtocolType {
        switch self {
        case .lookUpAllTicker:
            return NetworkProtocolType.rest
        case .lookUpSpecificTicker:
            return NetworkProtocolType.rest
        case .subscribeTiker:
            return NetworkProtocolType.websocket
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .lookUpAllTicker:
            return nil
        case .lookUpSpecificTicker(order: let order, payment: let payment):
            return ["order_currency": order, "payment_cyrrency": payment]
        case .subscribeTiker(symbol: let symbol):
            return ["symbols": symbol]
        }
    }
}
