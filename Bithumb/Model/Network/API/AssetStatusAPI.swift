//
//  AssetStatusAPI.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/14.
//

import Foundation

enum AssetStatusAPI {
    case lookUp(orderCurrency: String)
}

extension AssetStatusAPI: Requestable {
    var apiType: APIType {
        return .rest
    }
    
    var requestType: RequestType {
        return .assetStatus
    }
    
    var pathParameters: [String: Any]? {
        switch self {
        case .lookUp(let orderCurrency):
            var params = [String: Any]()
            params["orderCurrency"] = orderCurrency
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
