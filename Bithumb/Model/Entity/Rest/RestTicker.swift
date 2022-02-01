//
//  RestTicker.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/15.
//

import Foundation

struct RestTicker {
    let openPrice: Double?
    let closePrice: Double?
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
        case openPrice = "opening_price"
        case closePrice = "closing_price"
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
        openPrice = try? Double(values.decode(String.self, forKey: .openPrice))
        closePrice = try? Double(values.decode(String.self, forKey: .closePrice))
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

//MARK: - Convert To DTO
extension RestTicker {
    func toDomain(symbol: String) -> TickerDTO {
        var rateOfChange: Double? = nil
        var amountOfChange: Double? = nil
        
        if let previousDayClosingPrice = previousDayClosingPrice,
           let closePrice = closePrice,
           previousDayClosingPrice != 0 {
            rateOfChange = (closePrice / previousDayClosingPrice) - 1
            amountOfChange = closePrice - previousDayClosingPrice
        }
        
        return TickerDTO(symbol: symbol, data: .init(currentPrice: closePrice,
                                                     rateOfChange: rateOfChange,
                                                     amountOfChange: amountOfChange,
                                                     accumulatedTransactionAmount: accumulatedTransactionAmountMidnight,
                                                     previousDayClosingPrice: previousDayClosingPrice))
    }
}
