//
//  RestEndPoint.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct RestEndPoint: RestEndPointable {
    var path: String
    var httpMethod: HTTPMethodType
    var queryParameters: [String : Any]?
}
