//
//  Serviceable.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

protocol Serviceable {
    var networkConfigure: NetworkConfigurable { get }
}

protocol RestServiceable: Serviceable {
    func request(endPoint: RestEndPointable, completion: @escaping (Result<Data, Error>) -> Void)
}

protocol WebSocketServiceable: Serviceable {
    func register(delegate: WebSocketServiceDelegate)
    func connect(endPoint: WebSocketEndPointable)
    func disconnect()
    func write(message: SubscriptionMessage)
}

enum RestNetworkError: Error {
    case urlGeneration
    case abnormalResponse
    case notExistData
}
