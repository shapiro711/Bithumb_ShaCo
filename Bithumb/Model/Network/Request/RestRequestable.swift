//
//  Requestable.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/14.
//

import Foundation

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

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var methodName: String {
        return self.rawValue
    }
}

enum PathParameterType: Hashable {
    case orderCurrency
    case paymentCurrency
    case chartIntervals
}

protocol RestRequestable {
    var requestType: RequestType { get }
    var basicPath: String { get }
    var httpMethod: HTTPMethodType { get }
    var pathParameters: [PathParameterType: String]? { get }
    var queryParameters: [String: Any]? { get }
}
