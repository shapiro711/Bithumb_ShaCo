//
//  TickerDTO.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/18.
//

import Foundation

struct TickerDTO: DataTransferable {
    let symbol: String
    let data: TickerData
    
    struct TickerData {
        let currentPrice: Double
        let rateOfChange: Double
        let amountOfChange: Double
        let accumulatedTransactionAmount: Double
    }
}
