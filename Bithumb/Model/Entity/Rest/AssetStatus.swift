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
    
    var isAvailable: Bool {
        switch self {
        case .possible:
            return true
        case .impossible:
            return false
        }
    }
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

extension AssetStatus {
    func toDomain(symbol: String) -> AssetStatusDTO {
        return AssetStatusDTO(symbol: symbol, data: .init(isDepositAvailable: depositStatus?.isAvailable, isWithdrawalAvailable: withdrawalStatus?.isAvailable))
    }
}


