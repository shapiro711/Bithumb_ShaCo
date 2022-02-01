//
//  WebSocketSessionManager.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/20.
//

import Foundation

protocol WebSocketSessionDelegate: AnyObject {
    func didReceive(_ connectionEvent: WebSocketConnectionEvent)
    func didReceive(_ messageEvent: URLSessionWebSocketTask.Message)
    func didReceive(_ messageError: WebSocketMessageError)
}

protocol WebSocketSessionManageable {
    func register(delegate: WebSocketSessionDelegate)
    func start(request: URLRequest)
    func stop()
    func send(data: Data)
}

final class WebSocketSessionManager: NSObject, WebSocketSessionManageable {
    private var webSocketTask: URLSessionWebSocketTask?
    private weak var delegate: WebSocketSessionDelegate?
    
    func register(delegate: WebSocketSessionDelegate) {
        self.delegate = delegate
    }
    
    func start(request: URLRequest) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session.webSocketTask(with: request)
        receive()
        webSocketTask?.resume()
    }
    
    func stop() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func send(data: Data) {
        webSocketTask?.send(.data(data)) { [weak self] error in
            if let error = error {
                self?.delegate?.didReceive(.sendingFailed(error))
            }
        }
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.delegate?.didReceive(message)
                self?.receive()
            case .failure(let error):
                self?.delegate?.didReceive(.receivingFailed(error))
            }
        }
    }
}

extension WebSocketSessionManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        switch closeCode {
        case .normalClosure:
            delegate?.didReceive(.disconnected)
        default:
            delegate?.didReceive(.unintentionalDisconnection)
        }
    }
}
