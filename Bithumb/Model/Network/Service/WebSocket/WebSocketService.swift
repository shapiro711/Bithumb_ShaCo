//
//  WebSocketService.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

protocol WebSocketServiceDelegate: AnyObject {
    func didReceive(_ connectionEvent: WebSocketConnectionEvent)
    func didReceive(_ messageEvent: WebSocketResponseMessage)
    func didReceive(_ subscriptionEvent: WebSocketSubscriptionEvent)
    func didReceive(_ error: WebSocketCommonError)
}

final class WebSocketService: WebSocketServiceable {
    let networkConfigure: NetworkConfigurable
    private weak var delegate: WebSocketServiceDelegate?
    private let sessionManager: WebSocketSessionManageable
    
    init(
        networkConfigure: NetworkConfigurable = WebSocketConfigure(),
        sessionManager: WebSocketSessionManageable = WebSocketSessionManager()
    ) {
        self.networkConfigure = networkConfigure
        self.sessionManager = sessionManager
    }
    
    func register(delegate: WebSocketServiceDelegate) {
        self.delegate = delegate
    }
    
    func connect(endPoint: WebSocketEndPointable) {
        do {
            let request = try generateURLRequest(endPoint: endPoint)
            sessionManager.register(delegate: self)
            sessionManager.start(request: request)
        } catch {
            delegate?.didReceive(.urlGeneration)
        }
    }
    
    func disconnect() {
        sessionManager.stop()
    }
    
    func write(message: SubscriptionMessage) {
        do {
            let data = try JSONEncoder().encode(message)
            sessionManager.send(data: data)
        } catch {
            delegate?.didReceive(.encodingFailed)
        }
    }
    
    private func generateURL(endPoint: WebSocketEndPointable) throws -> URL {
        let baseURL = networkConfigure.baseURLString
        let fullPath = baseURL + endPoint.path
        guard let url = URL(string: fullPath) else {
            throw WebSocketCommonError.urlGeneration
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
    func didReceive(_ messageError: WebSocketMessageError) {
        delegate?.didReceive(.messageError(messageError))
    }
    
    func didReceive(_ connectionEvent: WebSocketConnectionEvent) {
        delegate?.didReceive(connectionEvent)
    }
    
    func didReceive(_ messageEvent: URLSessionWebSocketTask.Message) {
        switch WebSocketMessageHandler.parse(messageEvent) {
        case .error(let errorEvent):
            delegate?.didReceive(errorEvent)
        case .message(let messageEvent):
            delegate?.didReceive(messageEvent)
        case .subscription(let subsctiprionEvent):
            delegate?.didReceive(subsctiprionEvent)
        case .connectionEstablished:
            delegate?.didReceive(.connectedSuccessfully)
        }
    }
}
