//
//  NetworkMonitor.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/23.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private(set) var isConnected = false
    
    private init() { }
    
    func startMonitoring() {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
