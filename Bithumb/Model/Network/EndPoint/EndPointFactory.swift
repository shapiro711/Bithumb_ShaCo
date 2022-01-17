//
//  EndPointFactory.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct EndPointFactory {
    static func getRestEndPoint(request: RestRequestable) -> RestEndPointable {
        let path = RestPath(requestType: request.requestType, pathParameters: request.pathParameters)
        return RestEndPoint(path: path, queryParameters: request.queryParameters)
    }
}
