//
//  RestTicker.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/15.
//

import Foundation

struct RestTicker {
    let initialPrice: Double?
    let finalPrice: Double?
    let lowPrice: Double?
    let highPrice: Double?
    let accumulatedTransactionVolumeMidnight: Double?
    let accumulatedTransactionAmountMidnight: Double?
    let previousDayClosingPrice: Double?
    let accumulatedTransactionVolume24Hours: Double?
    let accumulatedTransactionAmount24Hours: Double?
    let amountOfChange: Double?
    let rateOfChange: Double?
    let dateTime: String?
}

extension RestTicker: Decodable {
    enum CodingKeys: String, CodingKey {
        case initialPrice = "opening_price"
        case finalPrice = "closing_price"
        case lowPrice = "min_price"
        case highPrice = "max_price"
        case accumulatedTransactionVolumeMidnight = "units_traded"
        case accumulatedTransactionAmountMidnight = "acc_trade_value"
        case previousDayClosingPrice = "prev_closing_price"
        case accumulatedTransactionVolume24Hours = "units_traded_24H"
        case accumulatedTransactionAmount24Hours = "acc_trade_value_24H"
        case amountOfChange = "fluctate_24H"
        case rateOfChange = "fluctate_rate_24H"
        case dateTime = "date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        initialPrice = try? Double(values.decode(String.self, forKey: .initialPrice))
        finalPrice = try? Double(values.decode(String.self, forKey: .finalPrice))
        lowPrice = try? Double(values.decode(String.self, forKey: .lowPrice))
        highPrice = try? Double(values.decode(String.self, forKey: .highPrice))
        accumulatedTransactionVolumeMidnight = try? Double(values.decode(String.self, forKey: .accumulatedTransactionVolumeMidnight))
        accumulatedTransactionAmountMidnight = try? Double(values.decode(String.self, forKey: .accumulatedTransactionAmountMidnight))
        previousDayClosingPrice = try? Double(values.decode(String.self, forKey: .previousDayClosingPrice))
        accumulatedTransactionVolume24Hours = try? Double(values.decode(String.self, forKey: .accumulatedTransactionVolume24Hours))
        accumulatedTransactionAmount24Hours = try? Double(values.decode(String.self, forKey: .accumulatedTransactionAmount24Hours))
        amountOfChange = try? Double(values.decode(String.self, forKey: .amountOfChange))
        rateOfChange = try? Double(values.decode(String.self, forKey: .rateOfChange))
        dateTime = try? values.decode(String.self, forKey: .dateTime)
    }
}

extension RestTicker {
    func toDomain(symbol: String) -> TickerDTO {
        return TickerDTO(symbol: symbol, data: .init(currentPrice: finalPrice,
                                                     rateOfChange: rateOfChange,
                                                     amountOfChange: amountOfChange,
                                                     accumulatedTransactionAmount: accumulatedTransactionAmount24Hours,
                                                     previousDayClosingPrice: previousDayClosingPrice))
    }
}
