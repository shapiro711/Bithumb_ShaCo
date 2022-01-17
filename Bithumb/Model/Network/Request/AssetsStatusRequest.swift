//
//  AssetStatusAPI.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/14.
//

import Foundation

enum AssetsStatusRequest {
    case lookUp(orderCurrency: String)
}

extension AssetsStatusRequest: RestRequestable {
    var requestType: RequestType {
        return .assetStatus
    }
    
    var httpMethod: HTTPMethodType {
        switch self {
        case .lookUp:
            return .get
        }
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
}
