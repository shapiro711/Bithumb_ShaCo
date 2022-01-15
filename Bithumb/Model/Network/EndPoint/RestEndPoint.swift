//
//  RestEndPoint.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct RestEndPoint: RestEndPointable {
    var path: PathRepresentable
    var httpMethod: HTTPMethodType = .get
    var pathParameters: [String : Any]?
    var queryParameters: [String : Any]?
}
