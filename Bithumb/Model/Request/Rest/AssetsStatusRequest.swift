//
//  AssetStatusAPI.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/14.
//

import Foundation

enum AssetsStatusRequest {
    case lookUpAll
}

extension AssetsStatusRequest: RestRequestable {
    var requestType: RequestType {
        return .assetStatus
    }
    
    var specificPath: String {
        return "/assetsstatus"
    }
    
    var httpMethod: HTTPMethodType {
        switch self {
        case .lookUpAll:
            return .get
        }
    }
    
    var pathParameters: [PathParameterType: String]? {
        switch self {
        case .lookUpAll:
            var params = [PathParameterType: String]()
            params[.orderCurrency] = "ALL"
            return params
        }
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var parser: (Data) -> Result<[AssetStatusDTO], RestError> {
        return parseAssetsStatus
    }
}

extension AssetsStatusRequest {
    private func parseAssetsStatus(from data: Data) -> Result<[AssetStatusDTO], RestError> {
        let parsedResult = RestResponseData<AssetStatus>.deserialize(data: data)
        switch parsedResult {
        case .success(let assetsStatus):
            return .success(assetsStatus.map { $0.value.toDomain(symbol: $0.key) })
        case .failure(let error):
            return .failure(error)
        }
    }
}
