//
//  TickerAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum TickerRequest {
    case lookUp(orderCurrency: String, paymentCurrency: String)
}

extension TickerRequest: RestRequestable {
    var requestType: RequestType {
        return .ticker
    }
    
    var httpMethod: HTTPMethodType {
        switch self {
        case .lookUp:
            return .get
        }
    }
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency):
            var params = [PathParameterType: String]()
            params[.orderCurrency] = orderCurrency
            params[.paymentCurrency] = paymentCurrency
            return params
        }
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
}
