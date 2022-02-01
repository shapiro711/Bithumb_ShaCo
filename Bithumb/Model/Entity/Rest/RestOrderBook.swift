//
//  RestOrderBook.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/13.
//

import Foundation

struct RestOrderBook {
    let dateTime: Double?
    let orderCurrency: String?
    let paymentCurrency: String?
    let bids: [RestOrder]?
    let asks: [RestOrder]?
}

extension RestOrderBook: Decodable {
    enum CodingKeys: String, CodingKey {
        case dateTime = "timestamp"
        case orderCurrency = "order_currency"
        case paymentCurrency = "payment_currency"
        case bids, asks
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try? Double(values.decode(String.self, forKey: .dateTime))
        orderCurrency = try? values.decode(String.self, forKey: .orderCurrency)
        paymentCurrency = try? values.decode(String.self, forKey: .paymentCurrency)
        bids = try? values.decode([RestOrder].self, forKey: .bids)
        asks = try? values.decode([RestOrder].self, forKey: .asks)
    }
}

struct RestOrder {
    let quantity: Double?
    let price: Double?
}

extension RestOrder: Decodable {
    enum CodingKeys: String, CodingKey {
        case quantity, price
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quantity = try? Double(values.decode(String.self, forKey: .quantity))
        price = try? Double(values.decode(String.self, forKey: .price))
    }
}

//MARK: - Convert To DTO
extension RestOrderBook {
    func toDomain() -> OrderBookDepthDTO {
        let bids = bids?.map { bid in
            OrderBookDepthDTO.OrderBookData(type: .bid, price: bid.price, quantity: bid.quantity, paymentCurrency: paymentCurrency)
        }
        let asks = asks?.map { ask in
            OrderBookDepthDTO.OrderBookData(type: .ask, price: ask.price, quantity: ask.quantity, paymentCurrency: paymentCurrency)
        }
        return OrderBookDepthDTO(bids: bids, asks: asks)
    }
}
