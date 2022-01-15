//
//  EndPointFactory.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct EndPointFactory {
    static func getRestEndPoint(request: Requestable) -> RestEndPointable {
        let path = RestPath(requestType: request.requestType)
        return RestEndPoint(path: path, pathParameters: request.pathParameters, queryParameters: request.queryParameters)
    }
    
    static func getWebSocketEndPoint(request: Requestable) -> WebSocketEndPointable {
        return WebSocketEndPoint(path: WebSocketPath(), messageParameters: request.messageParameters)
    }
}
