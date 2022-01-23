//
//  WebSocketOrderBook.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/13.
//

import Foundation

enum OrderType: String {
    case ask
    case bid
    
    init?(numberValue: Int?) {
        switch numberValue {
        case 1:
            self = .ask
        case 2:
            self = .bid
        default:
            return nil
        }
    }
}

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
    let orderType: OrderType?
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
        orderType = try? OrderType(rawValue: values.decode(String.self, forKey: .orderType))
        price = try? Double(values.decode(String.self, forKey: .price))
        quantity = try? Double(values.decode(String.self, forKey: .quantity))
        totalCount = try? Int(values.decode(String.self, forKey: .totalCount))
    }
}

extension WebSocketOrderBook {
    func toDomain() -> OrderBookDepthDTO {
        guard let orders = orders else {
            return OrderBookDepthDTO(bids: nil, asks: nil)
        }
        var bids: [OrderBookDepthDTO.OrderBookData] = []
        var asks: [OrderBookDepthDTO.OrderBookData] = []
        
        for order in orders {
            switch order.orderType {
            case .ask:
                asks.append(.init(type: order.orderType, price: order.price, quantity: order.quantity))
            case .bid:
                bids.append(.init(type: order.orderType, price: order.price, quantity: order.quantity))
            default:
                break
            }
        }
        return OrderBookDepthDTO(bids: bids, asks: asks)
    }
}
