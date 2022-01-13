//
//  WebSocketOrderbook.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/13.
//

import Foundation

struct WebSocketOrderBook {
    let orders: [WebSocketOrder]?
    let dateTime: Double?
}

extension WebSocketOrderBook: Decodable {
    enum CodingKeys: String, CodingKey {
        case orders = "list"
        case dateTime = "datetime"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try? Double(values.decode(String.self, forKey: .dateTime))
        orders = try? values.decode([WebSocketOrder].self, forKey: .orders)
    }
}

struct WebSocketOrder {
    let symbol: String?
    let orderType: String?
    let price: Double?
    let quantity: Double?
    let totalCount: Int?
}

extension WebSocketOrder: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol, orderType, price, quantity
        case totalCount = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try? values.decode(String.self, forKey: .symbol)
        orderType = try? values.decode(String.self, forKey: .orderType)
        price = try? Double(values.decode(String.self, forKey: .price))
        quantity = try? Double(values.decode(String.self, forKey: .quantity))
        totalCount = try? Int(values.decode(String.self, forKey: .totalCount))
    }
}
