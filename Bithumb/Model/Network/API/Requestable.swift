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
}

protocol Requestable {
    var apiType: APIType { get }
    var requestType: RequestType { get }
    var pathParameters: [String: Any]? { get }
    var queryParameters: [String: Any]? { get }
    var messageParameters: [String: Any]? { get }
}


