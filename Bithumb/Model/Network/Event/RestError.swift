//
//  RestError.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/23.
//

import Foundation

enum RestError: Error {
    case urlGeneration
    case abnormalResponse
    case notExistData
    case internetProblem
    case parsingFailed
    case undefined(Error)
}
