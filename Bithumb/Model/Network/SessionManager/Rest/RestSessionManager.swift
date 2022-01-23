//
//  RestSessionManager.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/17.
//

import Foundation

protocol RestSessionManageable {
    func request(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

struct RestSessionManager: RestSessionManageable {
    func request(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: completion)
        dataTask.resume()
    }
}
