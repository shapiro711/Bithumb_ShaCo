//
//  TransactionAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum TransactionRequest {
    case lookUp(orderCurrency: String, paymentCurrency: String, listCount: Int = 20)
    case subscribe(symbols: [String])
}

extension TransactionRequest: Requestable {
    var apiType: APIType {
        switch self {
        case .lookUp:
            return .rest
        case .subscribe:
            return .webSocket
        }
    }
    
    var requestType: RequestType {
        return .transaction
    }
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency, _):
            var params = [PathParameterType: String]()
            params[.orderCurrency] = orderCurrency
            params[.paymentCurrency] = paymentCurrency
            return params
        case .subscribe:
            return nil
        }
    }
    
    var queryParameters: [String: Any]? {
        switch self {
        case .lookUp(_, _, let listCount):
            var params = [String: Any]()
            params["count"] = listCount
            return params
        case .subscribe:
            return nil
        }
    }
    
    var message: SubscribeMessage? {
        switch self {
        case .lookUp:
            return nil
        case .subscribe(let symbols):
            return SubscribeMessage(type: requestType, symbols: symbols, criteriaOfChange: nil)
        }
    }
}
