//
//  TransactionAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum TransactionRequest {
    case lookUp(orderCurrency: String = "BTC", paymentCurrency: String = "KRW", listCount: Int = 20)
}

extension TransactionRequest: RestRequestable {
    var requestType: RequestType {
        return .transaction
    }
    
    var basicPath: String {
        return "transaction_history/"
    }
    
    var httpMethod: HTTPMethodType {
        switch self {
        case .lookUp:
            return .get
        }
    }
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency, _):
            var params = [PathParameterType: String]()
            params[.orderCurrency] = orderCurrency
            params[.paymentCurrency] = paymentCurrency
            return params
        }
    }
    
    var queryParameters: [String: Any]? {
        switch self {
        case .lookUp(_, _, let listCount):
            var params = [String: Any]()
            params["count"] = listCount
            return params
        }
    }
}
