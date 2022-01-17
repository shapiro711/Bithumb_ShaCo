//
//  EndPoints.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/15.
//

import Foundation

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



