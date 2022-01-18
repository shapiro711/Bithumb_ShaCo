//
//  CandlestickDTO.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/18.
//

import Foundation

struct CandlestickDTO: DataTransferable {
    let date: Date
    let initialPrice: Double
    let finalPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let volume: Double
}
