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
    
    var specificPath: String {
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
    
    var parser: (Data) -> Result<[TransactionDTO], Error> {
        return parseTransactions
    }
}

extension TransactionRequest {
    private func parseTransactions(from data: Data) -> Result<[TransactionDTO], Error> {
        let parsedResult = RestResponseData<[RestTransaction]>.decode(data: data)
        switch parsedResult {
        case .success(let transactions):
            return .success(transactions.map { $0.toDomain() })
        case .failure(let error):
            return .failure(error)
        }
    }
}
