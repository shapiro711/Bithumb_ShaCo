//
//  WebSocketTicker.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/12.
//

import Foundation

enum CriteriaOfChange: String {
    case thirtyMinutesAgo = "30M"
    case oneHourAgo = "1H"
    case twelveHoursAgo = "12H"
    case twentyFourHoursAgo = "24H"
    case yesterdayMidnight = "MID"
    
    var jsonValue: String {
        return self.rawValue
    }
}

struct WebSocketTicker {
    let symbol: String?
    let criteriaOfChange: CriteriaOfChange?
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
    let volumePower: Double?
    
    var date: Date? {
        guard let day = day, let time = time else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.date(from: day + time)
    }
}

extension WebSocketTicker: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol, time, lowPrice, highPrice, volumePower
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
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try? values.decode(String.self, forKey: .symbol)
        criteriaOfChange = try? CriteriaOfChange(rawValue: values.decode(String.self, forKey: .criteriaOfChange))
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
        volumePower = try? Double(values.decode(String.self, forKey: .volumePower))
    }
}

//MARK: - Convert To DTO
extension WebSocketTicker {
    func toDomain() -> TickerDTO {
        return TickerDTO(symbol: symbol, data: .init(currentPrice: finalPrice,
                                                     rateOfChange: rateOfChange,
                                                     amountOfChange: amountOfChange,
                                                     accumulatedTransactionAmount: accumulatedTransactionAmount,
                                                     previousDayClosingPrice: previousDayClosingPrice))
    }
}
