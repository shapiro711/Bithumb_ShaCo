//
//  Candlestick.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/13.
//

import Foundation

struct Candlestick {
    let dateTime: Double
    let initialPrice: String
    let finalPrice: String
    let highPrice: String
    let lowPrice: String
    let volume: String
    
    var date: Date {
        let nineHoursInSeconds: TimeInterval = 32400
        return Date(timeIntervalSince1970: dateTime / 1000 + nineHoursInSeconds)
    }
}

extension Candlestick: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        dateTime = try container.decode(Double.self)
        initialPrice = try container.decode(String.self)
        finalPrice = try container.decode(String.self)
        highPrice = try container.decode(String.self)
        lowPrice = try container.decode(String.self)
        volume = try container.decode(String.self)
    }
}

extension Candlestick {
    func toDomain() -> CandlestickDTO {
        return CandlestickDTO(date: date,
                              initialPrice: Double(initialPrice),
                              finalPrice: Double(finalPrice),
                              highPrice: Double(highPrice),
                              lowPrice: Double(lowPrice),
                              volume: Double(volume))
    }
}
