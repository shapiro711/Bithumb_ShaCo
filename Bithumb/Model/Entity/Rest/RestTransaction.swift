//
//  RestTransaction.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/13.
//

import Foundation

struct RestTransaction {
    let dateTime: String?
    let executionType: OrderType?
    let quantity: Double?
    let price: Double?
    let amount: Double?
    
    var date: Date? {
        guard let dateTime = dateTime else {
            return nil
        }
        
        let nineHoursInSeconds: TimeInterval = 32400
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = dateFormatter.date(from: dateTime)
        date?.addTimeInterval(nineHoursInSeconds)
        return date
    }
}

extension RestTransaction: Decodable {
    enum CodingKeys: String, CodingKey {
        case dateTime = "transaction_date"
        case executionType = "type"
        case quantity = "units_traded"
        case price
        case amount = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try? values.decode(String.self, forKey: .dateTime)
        executionType = try? OrderType(rawValue: values.decode(String.self, forKey: .executionType))
        quantity = try? Double(values.decode(String.self, forKey: .quantity))
        price = try? Double(values.decode(String.self, forKey: .price))
        amount = try? Double(values.decode(String.self, forKey: .amount))
    }
}

extension RestTransaction {
    func toDomain() -> TransactionDTO {
        return TransactionDTO(date: date, price: price, quantity: quantity, type: executionType)
    }
}
