//
//  AssetStatusAPI.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/14.
//

import Foundation

enum AssetStatusRequest {
    case lookUp(orderCurrency: String)
}

extension AssetStatusRequest: Requestable {
    var apiType: APIType {
        return .rest
    }
    
    var requestType: RequestType {
        return .assetStatus
    }
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUp(let orderCurrency):
            var params = [PathParameterType: String]()
            params[.orderCurrency] = orderCurrency
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
