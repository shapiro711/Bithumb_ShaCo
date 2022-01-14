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
    
    var parameters: [String: Any]? {
        var params = [String: Any]()
        
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency):
            params["orderCurrency"] = orderCurrency
            params["paymentCurrency"] = paymentCurrency
        case .subscribe(let symbols, let criteriaOfChange):
            params["symbols"] = symbols
            params["criteriaOfChange"] = criteriaOfChange
        }
        
        return params
    }
}
