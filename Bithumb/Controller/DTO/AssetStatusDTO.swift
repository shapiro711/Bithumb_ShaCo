//
//  AssetStatusDTO.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/18.
//

import Foundation

struct AssetStatusDTO: DataTransferable {
    let symbol: String
    let data: AssetStatusData
    
    var formattedDepositStatus: String {
        guard let isDepositAvailable = data.isDepositAvailable else {
            return "알 수 없음"
        }
        
        if isDepositAvailable {
            return "✓ 가능"
        } else {
            return "✗ 불가능"
        }
    }
    var formattedWithdrawStatus: String {
        guard let isWithdrawalAvailable = data.isWithdrawalAvailable else {
            return "알 수 없음"
        }
        
        if isWithdrawalAvailable {
            return "✓ 가능"
        } else {
            return "✗ 불가능"
        }
    }
    
    struct AssetStatusData {
        let isDepositAvailable: Bool?
        let isWithdrawalAvailable: Bool?
    }
}
