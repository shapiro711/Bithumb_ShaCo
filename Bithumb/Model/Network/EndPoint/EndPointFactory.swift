//
//  EndPointFactory.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct EndPointFactory {
    static func getRestEndPoint<Request: RestRequestable>(request: Request) -> RestEndPointable {
        let fullPath = mergeRestPaths(defaultPath: request.basicPath + request.specificPath, pathParameters: request.pathParameters)
        return RestEndPoint(path: fullPath, httpMethod: request.httpMethod, queryParameters: request.queryParameters)
    }
    
    private static func mergeRestPaths(defaultPath: String, pathParameters: [PathParameterType: String]?) -> String {
        guard let pathParameters = pathParameters else {
            return defaultPath
        }
        
        let underScore = "_"
        let slash = "/"
        var fullPath = defaultPath
        
        if let orderCurrency = pathParameters[.orderCurrency] {
            fullPath += orderCurrency
        }
        if let paymentCurrency = pathParameters[.paymentCurrency] {
            fullPath += underScore
            fullPath += paymentCurrency
        }
        if let chartIntervals = pathParameters[.chartIntervals] {
            fullPath += slash
            fullPath += chartIntervals
        }
        
        return fullPath
    }
}
