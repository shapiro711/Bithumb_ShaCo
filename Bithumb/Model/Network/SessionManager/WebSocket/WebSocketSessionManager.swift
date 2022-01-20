//
//  WebSocketSessionManager.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/20.
//

import Foundation

enum WebSocketMessageError: Error {
    case sendingFailed(Error)
    case receivingFailed(Error)
}

protocol WebSocketSessionDelegate: AnyObject {
    func didReceive(_ result: Result<URLSessionWebSocketTask.Message, WebSocketMessageError>)
}

protocol WebSocketSessionManageable {
    func register(delegate: WebSocketSessionDelegate?)
    func start(request: URLRequest)
    func stop()
    func send(data: Data)
}

final class WebSocketSessionManager: NSObject, WebSocketSessionManageable {
    private var webSocketTask: URLSessionWebSocketTask?
    private weak var delegate: WebSocketSessionDelegate?
    
    func register(delegate: WebSocketSessionDelegate?) {
        self.delegate = delegate
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
    
    func send(data: Data) {
        webSocketTask?.send(.data(data)) { [weak self] error in
            if let error = error {
                self?.delegate?.didReceive(.failure(.sendingFailed(error)))
            }
        }
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.delegate?.didReceive(.success(message))
            case .failure(let error):
                self?.delegate?.didReceive(.failure(.receivingFailed(error)))
            }
            
            self?.receive()
        }
    }
}

extension WebSocketSessionManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.webSocketTask = nil
    }
}
