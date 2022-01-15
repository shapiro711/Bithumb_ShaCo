//
//  TickerAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum TickerRequest {
    case lookUp(orderCurrency: String, paymentCurrency: String)
    case subscribe(symbols: [String], criteriaOfChange: [CriteriaOfChange])
}

extension TickerRequest: Requestable {
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
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency):
            var params = [PathParameterType: String]()
            params[.orderCurrency] = orderCurrency
            params[.paymentCurrency] = paymentCurrency
            return params
        case .subscribe:
            return nil
        }
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var message: SubscribeMessage? {
        switch self {
        case .lookUp:
            return nil
        case .subscribe(let symbols, let criteriaOfChange):
            return SubscribeMessage(type: requestType, symbols: symbols, criteriaOfChange: criteriaOfChange)
        }
    }
}
