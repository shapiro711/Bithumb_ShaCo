//
//  TickerAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/14.
//

import Foundation

enum TickerRequest {
    case lookUpAll(paymentCurrency: String = "KRW")
    case lookUp(orderCurrency: String = "BTC", paymentCurrency: String = "KRW")
}

extension TickerRequest: RestRequestable {
    var requestType: RequestType {
        return .ticker
    }
    
    var specificPath: String {
        return "/ticker"
    }
    
    var httpMethod: HTTPMethodType {
        switch self {
        case .lookUpAll:
            return .get
        case .lookUp:
            return .get
        }
    }
    
    var pathParameters: [PathParameterType: String]? {
        var params = [PathParameterType: String]()
        
        switch self {
        case .lookUpAll(let paymentCurrency):
            params[.orderCurrency] = "ALL"
            params[.paymentCurrency] = paymentCurrency
        case .lookUp(let orderCurrency, let paymentCurrency):
            params[.orderCurrency] = orderCurrency
            params[.paymentCurrency] = paymentCurrency
        }
        
        return params
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var parser: (Data) -> Result<[TickerDTO], RestError> {
        switch self {
        case .lookUpAll:
            return parseAllTicker
        case .lookUp:
            return parseTicker
        }
        
    }
}

extension TickerRequest {
    private var paymentCurrency: String {
        switch self {
        case .lookUpAll(let paymentCurrency):
            return paymentCurrency
        case .lookUp(_, let paymentCurrency):
            return paymentCurrency
        }
    }
    
    private var orderCurrency: String {
        switch self {
        case .lookUpAll:
            return "ALL"
        case .lookUp(let orderCurrency, _):
            return orderCurrency
        }
    }
    
    private func parseAllTicker(from data: Data) ->  Result<[TickerDTO], RestError> {
        let parsedResult = RestResponseData<RestTicker>.deserialize(data: data)
        switch parsedResult {
        case .success(let restTickers):
            return .success(restTickers.map {
                $0.value.toDomain(symbol: $0.key + "_" + paymentCurrency)
            })
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func parseTicker(from data: Data) -> Result<[TickerDTO], RestError> {
        let parsedResult = RestResponseData<RestTicker>.decode(data: data)
        switch parsedResult {
        case .success(let restTicker):
            return .success([restTicker.toDomain(symbol: orderCurrency + "_" + paymentCurrency)])
        case .failure(let error):
            return .failure(error)
        }
    }
}
