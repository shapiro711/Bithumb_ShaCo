//
//  SubscribeMessage.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct SubscribeMessage {
    let type: RequestType
    let symbols: [String]
    let criteriaOfChange: [CriteriaOfChange]?
}

extension SubscribeMessage: Encodable {
    enum CodingKeys: String, CodingKey {
        case type, symbols
        case criteriaOfChange = "tickTypes"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.jsonValue, forKey: .type)
        try container.encode(symbols, forKey: .symbols)
        try container.encodeIfPresent(criteriaOfChange?.map { $0.jsonValue }, forKey: .criteriaOfChange)
    }
}
