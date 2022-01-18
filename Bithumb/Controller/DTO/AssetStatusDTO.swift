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
    
    struct AssetStatusData {
        let depositStatus: Possibility
        let withdrawalStatus: Possibility
    }
}
