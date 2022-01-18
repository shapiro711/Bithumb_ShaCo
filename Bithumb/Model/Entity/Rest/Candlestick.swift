//
//  Candlestick.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/13.
//

import Foundation

struct Candlestick {
    let dateTime: Double
    let initialPrice: Double
    let finalPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let volume: Double
    
    var date: Date {
        return Date(timeIntervalSince1970: dateTime / 1000)
    }
    
    init(data: [Double]) {
        dateTime = data[0]
        initialPrice = data[1]
        finalPrice = data[2]
        highPrice = data[3]
        lowPrice = data[4]
        volume = data[5]
    }
}

extension Candlestick {
    func toDomain() -> CandlestickDTO {
        return CandlestickDTO(date: date, initialPrice: initialPrice, finalPrice: finalPrice, highPrice: highPrice, lowPrice: lowPrice, volume: volume)
    }
}
