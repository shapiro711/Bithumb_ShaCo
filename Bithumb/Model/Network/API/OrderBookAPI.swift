//
//  OrderBookAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum OrderBookAPI {
    case lookUp(orderCurrency: String, paymentCurrency: String, listCount: Int = 30)
    case subscribe(symbols: [String])
}

extension OrderBookAPI: Requestable {
    var apiType: APIType {
        switch self {
        case .lookUp:
            return .rest
        case .subscribe:
            return .webSocket
        }
    }
    
    var requestType: RequestType {
        return .orderBook
    }
    
    var pathParameters: [String]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency, _):
            var params = [String]()
            params.append(orderCurrency)
            params.append(paymentCurrency)
            return params
        case .subscribe:
            return nil
        }
    }
    
    var queryParameters: [String : Any]? {
        switch self {
        case .lookUp(_, _, let listCount):
            var params = [String: Any]()
            params["count"] = listCount
            return params
        case .subscribe:
            return nil
        }
    }
    
    var messageParameters: [String : Any]? {
        switch self {
        case .lookUp:
            return nil
        case .subscribe(let symbols):
            var params = [String: Any]()
            params["symbols"] = symbols
            return params
        }
    }
    
    
}
