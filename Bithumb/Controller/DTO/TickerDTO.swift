//
//  TickerDTO.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/18.
//

import Foundation

struct TickerDTO: DataTransferable {
    let symbol: String?
    let data: TickerData
    
    var formattedSymbol: String {
        guard let symbol = symbol else {
            return .hypen
        }
        return symbol.replacingOccurrences(of: String.underScore, with: String.slash)
    }
    
    var formattedCurrentPrice: String {
        guard let currentPrice = data.currentPrice,
              let symbol = symbol else {
            return .hypen
        }
        let numberFormatter = NumberFormatter()
        if symbol.hasSuffix("KRW") {
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
        } else {
            numberFormatter.numberStyle = .none
            numberFormatter.minimumFractionDigits = 8
            numberFormatter.maximumFractionDigits = 8
        }
        return numberFormatter.string(from: NSNumber(value: currentPrice)) ?? .hypen
    }
    var formattedRateOfChange: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        guard let rateOfChange = data.rateOfChange,
              let formattedRateOfChange = numberFormatter.string(from: NSNumber(value: rateOfChange/100)) else {
                  return "0.00%"
        }
        
        return formattedRateOfChange
    }
    var formattedAmountOfChange: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 4
        
        guard let symbol = symbol,
              symbol.hasSuffix("KRW"),
              let amountOfChange = data.amountOfChange,
              let formattedAmountOfChange = numberFormatter.string(from: NSNumber(value: amountOfChange)) else {
                  return ""
        }
        
        return formattedAmountOfChange
    }
    var formattedTransactionAmount: String {
        guard var accumulatedTransactionAmount = data.accumulatedTransactionAmount,
              let symbol = symbol else {
            return .hypen
        }
        
        let numberFormatter = NumberFormatter()
        var currency = ""
        
        if symbol.hasSuffix("KRW") {
            accumulatedTransactionAmount /= 1000000
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 0
            currency = "백만"
        } else {
            numberFormatter.minimumFractionDigits = 3
            numberFormatter.maximumFractionDigits = 3
            currency = "BTC"
        }
        
        guard let formattedTransactionAmount = numberFormatter.string(from: NSNumber(value: accumulatedTransactionAmount)) else {
            return .hypen
        }
        
        return formattedTransactionAmount + currency
    }
    
    struct TickerData {
        let currentPrice: Double?
        let rateOfChange: Double?
        let amountOfChange: Double?
        let accumulatedTransactionAmount: Double?
    }
}

private extension String {
    static let hypen = "-"
    static let underScore = "_"
    static let slash = "/"
}
