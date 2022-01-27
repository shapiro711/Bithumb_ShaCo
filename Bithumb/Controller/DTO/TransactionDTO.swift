//
//  TransactionDTO.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/18.
//

import Foundation

struct TransactionDTO: DataTransferable {
    let date: Date?
    let price: Double?
    let quantity: Double?
    let type: OrderType?
    var symbol: String?
    
    var formattedPrice: String {
        guard let price = price,
              let symbol = symbol else {
            return .hypen
        }
        
        let currencies = symbol.split(separator: "_").map { String($0) }
        guard let paymentCurrency = currencies.last else {
            return .hypen
        }
        
        let numberFormatter = NumberFormatter()
        
        if paymentCurrency == "KRW" {
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
        } else {
            numberFormatter.numberStyle = .none
            numberFormatter.minimumFractionDigits = 8
            numberFormatter.maximumFractionDigits = 8
        }
        return numberFormatter.string(from: NSNumber(value: price)) ?? .hypen
    }
    var formattedDate: String {
        guard let date = date else {
            return "--:--:--"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    var formattedQuantity: String {
        guard let quantity = quantity else {
            return .hypen
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 8
        numberFormatter.maximumFractionDigits = 8
        
        return numberFormatter.string(from: NSNumber(value: quantity)) ?? .hypen
    }
}
