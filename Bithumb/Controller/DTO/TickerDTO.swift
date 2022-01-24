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
    
    struct TickerData {
        let currentPrice: Double?
        let rateOfChange: Double?
        let amountOfChange: Double?
        let accumulatedTransactionAmount: Double?
        
        var formattedCurrentPrice: String {
            guard let currentPrice = currentPrice else {
                return .hypen
            }
            let numberFormatter = NumberFormatter()
            if currentPrice >= 0 {
                numberFormatter.numberStyle = .decimal
            } else {
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
            
            guard let rateOfChange = rateOfChange,
                  let formattedRateOfChange = numberFormatter.string(from: NSNumber(value: rateOfChange/100)) else {
                      return .hypen
            }
            
            return formattedRateOfChange
        }
        var formattedAmountOfChange: String {
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 4
            
            guard let amountOfChange = amountOfChange,
                  let formattedAmountOfChange = numberFormatter.string(from: NSNumber(value: amountOfChange)) else {
                      return .hypen
            }
            
            return formattedAmountOfChange
        }
        var formattedTransactionAmount: String {
            guard var accumulatedTransactionAmount = accumulatedTransactionAmount else {
                return .hypen
            }
            
            accumulatedTransactionAmount /= 1000000
            let numberFormatter = NumberFormatter()
            
            if accumulatedTransactionAmount >= 0 {
                numberFormatter.numberStyle = .decimal
                numberFormatter.maximumFractionDigits = 0
            } else {
                numberFormatter.maximumFractionDigits = 6
            }
            
            guard let formattedTransactionAmount = numberFormatter.string(from: NSNumber(value: accumulatedTransactionAmount)) else {
                return .hypen
            }
            
            return formattedTransactionAmount + "백만"
        }
    }
}

private extension String {
    static let hypen = "-"
    static let underScore = "_"
    static let slash = "/"
}
