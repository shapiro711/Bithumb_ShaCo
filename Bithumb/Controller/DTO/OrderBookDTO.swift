//
//  OrderBookDTO.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/18.
//

import Foundation

struct OrderBookDepthDTO: DataTransferable {
    let bids: [OrderBookData]?
    let asks: [OrderBookData]?
    
    struct OrderBookData {
        let type: OrderType?
        let price: Double?
        let quantity: Double?
    }
}
