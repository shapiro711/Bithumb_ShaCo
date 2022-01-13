//
//  Candlestick.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/13.
//

import Foundation

struct CandlestickHistory {
    let list: [[Double]]
    
    var candlesticks: [Candlestick] {
        return list.map { candleData in
            Candlestick(
                dateTime: candleData[0],
                initialPrice: candleData[1],
                finalPrice: candleData[2],
                highPrice: candleData[3],
                lowPrice: candleData[4],
                volume: candleData[5]
            )
        }
    }
}

extension CandlestickHistory: Decodable {
    enum CodingKeys: String, CodingKey {
        case list = "data"
    }
}

struct Candlestick {
    let dateTime: Double
    let initialPrice: Double
    let finalPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let volume: Double
}
