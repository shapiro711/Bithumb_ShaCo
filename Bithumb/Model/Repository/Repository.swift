//
//  Repository.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/19.
//

import Foundation

protocol Repositoryable {
    var restService: RestServiceable { get }
    var webSocketService: WebSocketServiceable { get }
    
    func execute<Request: RestRequestable>(request: Request, completion: @escaping (Result<Request.TargetDTO, RestError>) -> Void)
    func execute(request: WebSocketRequest)
    func register(delegate: WebSocketDelegate)
}

protocol WebSocketDelegate: AnyObject {
    func didReceive(_ connectionEvent: WebSocketConnectionEvent)
    func didReceive(_ messageEvent: WebSocketResponseMessage)
    func didReceive(_ subscriptionEvent: WebSocketSubscriptionEvent)
    func didReceive(_ error: WebSocketCommonError)
}

final class Repository: Repositoryable {
    let restService: RestServiceable
    let webSocketService: WebSocketServiceable
    private weak var delegate: WebSocketDelegate?
    
    init(restService: RestServiceable = RestService(), webSocketService: WebSocketServiceable = WebSocketService()) {
        self.restService = restService
        self.webSocketService = webSocketService
    }
    
    private func isInternetConnected() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
}

extension Repository {
    func execute<Request: RestRequestable>(request: Request, completion: @escaping (Result<Request.TargetDTO, RestError>) -> Void) {
        guard isInternetConnected() else {
            return completion(.failure(.internetProblem))
        }
        let endPoint = EndPointFactory.makeRestEndPoint(from: request)
        restService.request(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                let parsedResult = request.parser(data)
                switch parsedResult {
                case .success(let DTO):
                    completion(.success(DTO))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension Repository: WebSocketServiceDelegate {
    func register(delegate: WebSocketDelegate) {
        self.delegate = delegate
    }
    
    func execute(request: WebSocketRequest) {
        switch request {
        case .connect(let target):
            guard isInternetConnected() else {
                delegate?.didReceive(.failedToConnect)
                return 
            }
            let endPoint = EndPointFactory.makeWebSocketEndPoint(from: target)
            webSocketService.register(delegate: self)
            webSocketService.connect(endPoint: endPoint)
        case .disconnect:
            webSocketService.disconnect()
        case .send(let message):
            let subscriptionMessage = MessageFactory.makeSubscriptionMessage(from: message)
            webSocketService.write(message: subscriptionMessage)
        }
    }
    
    func didReceive(_ connectionEvent: WebSocketConnectionEvent) {
        delegate?.didReceive(connectionEvent)
    }
    
    func didReceive(_ messageEvent: WebSocketResponseMessage) {
        delegate?.didReceive(messageEvent)
    }
    
    func didReceive(_ subscriptionEvent: WebSocketSubscriptionEvent) {
        delegate?.didReceive(subscriptionEvent)
    }
    
    func didReceive(_ error: WebSocketCommonError) {
        delegate?.didReceive(error)
    }
}
