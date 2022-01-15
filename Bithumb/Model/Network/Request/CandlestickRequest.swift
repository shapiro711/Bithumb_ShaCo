//
//  CandlestickAPI.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

enum ChartInterval: String {
    case oneMinute = "1m"
    case threeMinutes = "3m"
    case fiveMinutes = "5m"
    case tenMinutes = "10m"
    case thirtyMinutes = "30m"
    case oneHour = "1h"
    case sixHours = "6h"
    case twelveHours = "12h"
    case twentyFourHours = "24h"
    
    var pathValue: String {
        return self.rawValue
    }
}

enum CandlestickRequest {
    case lookUp(orderCurrency: String, paymentCurrency: String, chartIntervals: ChartInterval)
}

extension CandlestickRequest: Requestable {
    var apiType: APIType {
        return .rest
    }
    
    var requestType: RequestType {
        return .candlestick
    }
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUp(let orderCurrency, let paymentCurrency, let chartIntervals):
            var params = [PathParameterType: String]()
            params[.orderCurrency] = orderCurrency
            params[.paymentCurrency] = paymentCurrency
            params[.chartIntervals] = chartIntervals.pathValue
            return params
        }
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var message: SubscribeMessage? {
        return nil
    }
}
