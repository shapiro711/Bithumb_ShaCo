//
//  CandlestickAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

enum CandlestickAPI {
    case lookUp(orderCurrency: String, paymentCurrency: String, chartIntervals: String)
}

extension CandlestickAPI: Requestable {
    var apiType: APIType {
        return .rest
    }
    
    var requestType: RequestType {
        return .candlestick
    }
    
    var pathParameters: [String: Any]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency, let chartIntervals):
            var params = [String: Any]()
            params["orderCurrency"] = orderCurrency
            params["paymentCurrency"] = paymentCurrency
            params["chartIntervals"] = chartIntervals
            return params
        }
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var messageParameters: [String: Any]? {
        return nil
    }
}
