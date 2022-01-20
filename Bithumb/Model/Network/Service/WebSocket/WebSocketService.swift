//
//  WebSocketService.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

final class WebSocketService: WebSocketServiceable {
    let networkConfigure: NetworkConfigurable
    private let sessionManager: WebSocketSessionManageable
    
    init(
        networkConfigure: NetworkConfigurable = WebSocketConfigure(),
        sessionManager: WebSocketSessionManageable = WebSocketSessionManager()
    ) {
        self.networkConfigure = networkConfigure
        self.sessionManager = sessionManager
    }
    
    func connect(endPoint: WebSocketEndPointable) {
        do {
            let request = try generateURLRequest(endPoint: endPoint)
            sessionManager.register(delegate: self)
            sessionManager.start(request: request)
        } catch {
            
        }
    }
    
    func disconnect() {
        sessionManager.register(delegate: nil)
    }
    
    func write() {
        
    }
    
    private func generateURL(endPoint: WebSocketEndPointable) throws -> URL {
        let baseURL = networkConfigure.baseURLString
        let fullPath = baseURL + endPoint.path
        guard let url = URL(string: fullPath) else {
            throw NetworkError.urlGeneration
        }
        return url
    }
    
    private func generateURLRequest(endPoint: WebSocketEndPointable) throws -> URLRequest {
        let url = try generateURL(endPoint: endPoint)
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}

extension WebSocketService: WebSocketSessionDelegate {
    func didReceive(_ result: Result<URLSessionWebSocketTask.Message, WebSocketMessageError>) {
        
    }
}
