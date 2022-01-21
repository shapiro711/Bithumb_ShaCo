//
//  WebSocketEvent.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/21.
//

import Foundation

enum WebSocketConnectionEvent {
    case connectedSuccessfully
    case failedToConnect
    case disconnected
    case unintentionalDisconnection
}

enum WebSocketSubscriptionEvent {
    case subscribedSuccessfully
    case failedToSubscribe
}

enum WebSocketCommonError: Error {
    case urlGeneration
    case encodingFailed
    case decodingFailed
    case messageError(WebSocketMessageError)
}

enum WebSocketResponseMessage {
    case ticker(TickerDTO)
    case orderBook(OrderBookDepthDTO)
    case transaction([TransactionDTO])
    case unsupported
}

enum WebSocketMessageError: Error {
    case sendingFailed(Error)
    case receivingFailed(Error)
}
