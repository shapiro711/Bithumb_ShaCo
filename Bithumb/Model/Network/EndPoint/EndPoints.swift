//
//  EndPoints.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/15.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var methodName: String {
        return self.rawValue
    }
}

protocol EndPointable {
    var path: PathRepresentable { get }
}

protocol WebSocketEndPointable: EndPointable {
    var message: SubscriptionMessage? { get }
}

protocol RestEndPointable: EndPointable {
    var httpMethod: HTTPMethodType { get }
    var queryParameters: [String: Any]? { get }
}



