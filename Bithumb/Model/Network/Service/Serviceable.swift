//
//  Serviceable.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

protocol Serviceable {
    var networkConfigure: NetworkConfigurable { get }
}

protocol RestServiceable: Serviceable {
    func request(endPoint: RestEndPointable, completion: @escaping (Result<Data, Error>) -> Void)
}

protocol WebSocketServiceable: Serviceable {
    
}

enum RestNetworkError: Error {
    case urlGeneration
    case abnormalResponse
    case notExistData
}
