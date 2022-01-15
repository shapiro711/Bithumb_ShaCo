//
//  Path.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

protocol PathRepresentable {
    static var basicPath: String { get }
    var specializedPath: String { get }
}

struct RestPath: PathRepresentable {
    static var basicPath: String {
        return "public/"
    }
    var specializedPath: String
    
    init(requestType: RequestType) {
        switch requestType {
        case .ticker:
            specializedPath =  Self.basicPath + "ticker/"
        case .orderBook:
            specializedPath =  Self.basicPath + "orderbook/"
        case .transaction:
            specializedPath =  Self.basicPath + "transaction_history/"
        case .assetStatus:
            specializedPath =  Self.basicPath + "assetsstatus/"
        case .candlestick:
            specializedPath =  Self.basicPath + "candlestick/"
        }
    }
}

struct WebSocketPath: PathRepresentable {
    static var basicPath: String {
        return "pub/"
    }
    
    var specializedPath: String {
        return Self.basicPath + "ws"
    }
}
