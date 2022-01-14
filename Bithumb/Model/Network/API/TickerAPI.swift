//
//  TickerAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum TickerAPI {
    case lookUp(orderCurrency: String, paymentCurrency: String)
    case subscribe(symbols: [String], criteriaOfChange: [String])
}

extension TickerAPI: Requestable {
    var apiType: APIType {
        switch self {
        case .lookUp:
            return .rest
        case .subscribe:
            return .webSocket
        }
    }
    
    var requestType: RequestType {
        return .ticker
    }
    
    var pathParameters: [String: Any]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency):
            var params = [String: Any]()
            params["orderCurrency"] = orderCurrency
            params["paymentCurrency"] = paymentCurrency
            return params
        case .subscribe:
            return nil
        }
    }
    
    var queryParameters: [String : Any]? {
        return nil
    }
    
    var messageParameters: [String : Any]? {
        switch self {
        case .lookUp:
            return nil
        case .subscribe(let symbols, let criteriaOfChange):
            var params = [String: Any]()
            params["symbols"] = symbols
            params["criteriaOfChange"] = criteriaOfChange
            return params
        }
    }
}
