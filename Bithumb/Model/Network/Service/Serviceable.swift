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
    
}

enum RestNetworkError: Error {
    case urlGeneration
    case abnormalResponse
    case notExistData
}

enum WebSocketEvent {
    case connected
    case subscribed
    case disconnected
    case receive(WebSocketResponseMessage)
    case error(WebSocketError)
}

enum WebSocketResponseMessage {
    case ticker(TickerDTO)
    case orderBook(OrderBookDepthDTO)
    case transaction([TransactionDTO])
    case unsupported
}

enum WebSocketError: Error {
    case urlGeneration
    case messageError(WebSocketMessageError)
    case encodingFailed
    case decodingFailed
    case connectionFailed
    case subscriptionFailed
}
