//
//  WebSocketTransaction.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/13.
//

import Foundation

enum Trend: String {
    case up
    case down = "dn"
}

struct WebSocketTransactionHistory {
    let transactions: [WebSocketTransaction]?
}

extension WebSocketTransactionHistory: Decodable {
    enum CodingKeys: String, CodingKey {
        case transactions = "list"
    }
}

struct WebSocketTransaction {
    let symbol: String?
    let executionType: OrderType?
    let price: Double?
    let quantity: Double?
    let amount: Double?
    let dateTime: String?
    let trend: Trend?
    
    var date: Date? {
        guard let dateTime = dateTime?.split(separator: ".").first else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: String(dateTime))
    }
}

extension WebSocketTransaction: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol
        case executionType = "buySellGb"
        case price = "contPrice"
        case quantity = "contQty"
        case amount = "contAmt"
        case dateTime = "contDtm"
        case trend = "updn"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try? values.decode(String.self, forKey: .symbol)
        executionType = try? OrderType(numberValue: Int(values.decode(String.self, forKey: .executionType)))
        price = try? Double(values.decode(String.self, forKey: .price))
        quantity = try? Double(values.decode(String.self, forKey: .quantity))
        amount = try? Double(values.decode(String.self, forKey: .amount))
        dateTime = try? values.decode(String.self, forKey: .dateTime)
        trend = try? Trend(rawValue: values.decode(String.self, forKey: .trend))
    }
}
