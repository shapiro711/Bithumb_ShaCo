//
//  Ticker.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/12.
//

import Foundation

struct Ticker {
    let symbol: String?
    let criteriaOfChange: String?
    let day: String?
    let time: String?
    let initialPrice: Double?
    let finalPrice: Double?
    let lowPrice: Double?
    let highPrice: Double?
    let accumulatedTransactionAmount: Double?
    let accumulatedTransactionVolume: Double?
    let accumulatedSellVolume: Double?
    let accumulatedBuyVolume: Double?
    let previousDayClosingPrice: Double?
    let rateOfChange: Double?
    let amountOfChange: Double?
    let executionPower: Double?
    
    var date: Date? {
        guard let day = day, let time = time else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.date(from: day + time)
    }
}

extension Ticker: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol, time, lowPrice, highPrice
        case criteriaOfChange = "tickType"
        case day = "date"
        case initialPrice = "openPrice"
        case finalPrice = "closePrice"
        case accumulatedTransactionAmount = "value"
        case accumulatedTransactionVolume = "volume"
        case accumulatedSellVolume = "sellVolume"
        case accumulatedBuyVolume = "buyVolume"
        case previousDayClosingPrice = "prevClosePrice"
        case rateOfChange = "chgRate"
        case amountOfChange = "chgAmt"
        case executionPower = "volumePower"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try? values.decode(String.self, forKey: .symbol)
        criteriaOfChange = try? values.decode(String.self, forKey: .criteriaOfChange)
        day = try? values.decode(String.self, forKey: .day)
        time = try? values.decode(String.self, forKey: .time)
        initialPrice = try? Double(values.decode(String.self, forKey: .initialPrice))
        finalPrice = try? Double(values.decode(String.self, forKey: .finalPrice))
        lowPrice = try? Double(values.decode(String.self, forKey: .lowPrice))
        highPrice = try? Double(values.decode(String.self, forKey: .highPrice))
        accumulatedTransactionAmount = try? Double(values.decode(String.self, forKey: .accumulatedTransactionAmount))
        accumulatedTransactionVolume = try? Double(values.decode(String.self, forKey: .accumulatedTransactionVolume))
        accumulatedSellVolume = try? Double(values.decode(String.self, forKey: .accumulatedSellVolume))
        accumulatedBuyVolume = try? Double(values.decode(String.self, forKey: .accumulatedBuyVolume))
        previousDayClosingPrice = try? Double(values.decode(String.self, forKey: .previousDayClosingPrice))
        rateOfChange = try? Double(values.decode(String.self, forKey: .rateOfChange))
        amountOfChange = try? Double(values.decode(String.self, forKey: .amountOfChange))
        executionPower = try? Double(values.decode(String.self, forKey: .executionPower))
    }
}
