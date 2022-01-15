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

enum RestPath {
    case ticker
    case orderBook
    case transaction
    case assetStatus
    case candlestick
}

extension RestPath: PathRepresentable {
    static var basicPath: String {
        return "public/"
    }
    
    var specializedPath: String {
        switch self {
        case .ticker:
            return Self.basicPath + "ticker/"
        case .orderBook:
            return Self.basicPath + "orderbook/"
        case .transaction:
            return Self.basicPath + "transaction_history/"
        case .assetStatus:
            return Self.basicPath + "assetsstatus/"
        case .candlestick:
            return Self.basicPath + "candlestick/"
        }
    }
}

enum WebSocketPath {
    case common
}

extension WebSocketPath: PathRepresentable {
    static var basicPath: String {
        return "pub/"
    }
    
    var specializedPath: String {
        switch self {
        case .common:
            return Self.basicPath + "ws"
        }
    }
}
