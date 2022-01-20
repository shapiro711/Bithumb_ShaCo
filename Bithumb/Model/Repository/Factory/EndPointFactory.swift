//
//  EndPointFactory.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct EndPointFactory {
    static func makeRestEndPoint<Request: RestRequestable>(from request: Request) -> RestEndPointable {
        let fullPath = mergeRestPaths(basicPath: request.basicPath,
                                      specificPath: request.specificPath,
                                      pathParameters: request.pathParameters)
        return RestEndPoint(path: fullPath,
                            httpMethod: request.httpMethod,
                            queryParameters: request.queryParameters)
    }
    
    static func makeWebSocketEndPoint(from webSocketType: WebSocketType) -> WebSocketEndPointable {
        return WebSocketEndPoint(path: webSocketType.path + webSocketType.specificPath)
    }
    
    private static func mergeRestPaths(basicPath: String,
                                       specificPath: String,
                                       pathParameters: [PathParameterType: String]?) -> String {
        let underScore = "_"
        let slash = "/"
        var fullPath = basicPath + specificPath
        
        guard let pathParameters = pathParameters else {
            return fullPath
        }
        
        if let orderCurrency = pathParameters[.orderCurrency] {
            fullPath += slash
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
