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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: dateTime)
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

//MARK: - Convert To DTO
extension RestTransaction {
    func toDomain() -> TransactionDTO {
        return TransactionDTO(date: date, price: price, quantity: quantity, type: executionType, symbol: nil)
    }
}
