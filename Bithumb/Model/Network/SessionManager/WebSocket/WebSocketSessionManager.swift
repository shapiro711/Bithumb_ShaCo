//
//  WebSocketSessionManager.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/20.
//

import Foundation

protocol WebSocketSessionManageable {
    
}

final class WebSocketSessionManager: NSObject, WebSocketSessionManageable {
    private var webSocketTask: URLSessionWebSocketTask?
    
    func register() {
        
    }
    
    func start(request: URLRequest) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session.webSocketTask(with: request)
        receive()
        webSocketTask?.resume()
    }
    
    func stop() {
        webSocketTask?.cancel()
    }
    
    func send() {
        
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.propagate(message)
            case .failure(let error):
                self?.propagate(error)
            }
    
            self?.receive()
        }
    }
    
    private func propagate(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            break
        case .string(let string):
            break
        }
    }
    
    private func propagate(_ error: Error) {
        
    }
}

extension WebSocketSessionManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.webSocketTask = nil
    }
}
