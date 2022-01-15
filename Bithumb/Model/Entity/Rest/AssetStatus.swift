//
//  AssetStatus.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/13.
//

import Foundation

enum Possibility: Int {
    case possible = 1
    case impossible = 0
}

struct AssetStatus {
    let depositStatus: Possibility?
    let withdrawalStatus: Possibility?
}

extension AssetStatus: Decodable {
    enum CodingKeys: String, CodingKey {
        case depositStatus = "deposit_status"
        case withdrawalStatus = "withdrawal_status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        depositStatus = try? Possibility(rawValue: values.decode(Int.self, forKey: .depositStatus))
        withdrawalStatus = try? Possibility(rawValue: values.decode(Int.self, forKey: .withdrawalStatus))
    }
}
