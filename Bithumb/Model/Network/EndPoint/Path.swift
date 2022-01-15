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
    
    init(requestType: RequestType, pathParameters: [String: Any]?) {
        var specializedPath = Self.basicPath
        
        switch requestType {
        case .ticker:
            specializedPath += "ticker/"
            specializedPath.append(path: pathParameters?["orderCurrency"], alternativePath: "ALL")
            specializedPath += "_"
            specializedPath.append(path: pathParameters?["paymentCurrency"], alternativePath: "KRW")
        case .orderBook:
            specializedPath += "orderbook/"
            specializedPath.append(path: pathParameters?["orderCurrency"], alternativePath: "ALL")
            specializedPath += "_"
            specializedPath.append(path: pathParameters?["paymentCurrency"], alternativePath: "KRW")
        case .transaction:
            specializedPath += "transaction_history/"
            specializedPath.append(path: pathParameters?["orderCurrency"], alternativePath: "ALL")
            specializedPath += "_"
            specializedPath.append(path: pathParameters?["paymentCurrency"], alternativePath: "KRW")
        case .assetStatus:
            specializedPath += "assetsstatus/"
            specializedPath.append(path: pathParameters?["orderCurrency"], alternativePath: "ALL")
        case .candlestick:
            specializedPath += "candlestick/"
            specializedPath.append(path: pathParameters?["orderCurrency"], alternativePath: "ALL")
            specializedPath += "_"
            specializedPath.append(path: pathParameters?["paymentCurrency"], alternativePath: "KRW")
            specializedPath += "/"
            specializedPath.append(path: pathParameters?["chartIntervals"], alternativePath: "24h")
        }
        self.specializedPath = specializedPath
    }
}

private extension String {
    mutating func append(path: Any?, alternativePath: String) {
        if let path = path {
            self += "\(path)"
        } else {
            self += alternativePath
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
