//
//  OrderBookDTO.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/18.
//

import Foundation

struct OrderBookDepthDTO: DataTransferable {
    let bids: [OrderBookData]?
    let asks: [OrderBookData]?
    
    struct OrderBookData {
        let type: OrderType?
        let price: Double?
        let quantity: Double?
        let paymentCurrency: String?
        
        var formattedPrice: String {
            guard let price = price,
                  let paymentCurrency = paymentCurrency else {
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
        
        var formattedQuantity: String {
            guard let quantity = quantity else {
                return .hypen
            }
            
            let numberFormatter = NumberFormatter()
            
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 4
            numberFormatter.maximumFractionDigits = 4
            
            return numberFormatter.string(from: NSNumber(value: quantity)) ?? .hypen
        }
    }
}

