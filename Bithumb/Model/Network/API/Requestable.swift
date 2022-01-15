//
//  Requestable.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/14.
//

import Foundation

enum APIType {
    case rest
    case webSocket
}

enum RequestType {
    case ticker
    case orderBook
    case transaction
    case assetStatus
    case candlestick
    
    var jsonValue: String {
        switch self {
        case .ticker:
            return "ticker"
        case .orderBook:
            return "orderbookdepth"
        case .transaction:
            return "transaction"
        default:
            return ""
        }
    }
}

protocol Requestable {
    var apiType: APIType { get }
    var requestType: RequestType { get }
    var pathParameters: [String: Any]? { get }
    var queryParameters: [String: Any]? { get }
    var message: SubscribeMessage? { get }
}
