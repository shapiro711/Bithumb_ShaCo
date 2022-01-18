//
//  TransactionDTO.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/18.
//

import Foundation

struct TransactionDTO: DataTransferable {
    let date: Date
    let price: Double
    let quantity: Double
    let type: OrderType
}
