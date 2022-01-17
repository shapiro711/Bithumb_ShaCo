//
//  EndPointFactory.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct EndPointFactory {
    static func getRestEndPoint(request: RestRequestable) -> RestEndPointable {
        let fullPath = mergeRestPaths(basicPath: request.basicPath, pathParameters: request.pathParameters)
        return RestEndPoint(path: fullPath, httpMethod: request.httpMethod, queryParameters: request.queryParameters)
    }
    
    private static func mergeRestPaths(basicPath: String, pathParameters: [PathParameterType: String]?) -> String {
        guard let pathParameters = pathParameters else {
            return basicPath
        }
        
        let underScore = "_"
        let slash = "/"
        var fullPath = basicPath
        
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
