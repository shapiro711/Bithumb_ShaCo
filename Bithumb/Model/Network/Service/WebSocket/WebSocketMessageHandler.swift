//
//  WebSocketMessageHandler.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/21.
//

import Foundation

enum MessageParsingResult {
    case message(WebSocketResponseMessage)
    case subscription(WebSocketSubscriptionEvent)
    case error(WebSocketCommonError)
}

struct WebSocketMessageHandler {
    static func parse(_ message: URLSessionWebSocketTask.Message) -> MessageParsingResult {
        switch message {
        case .string(let stringMessage):
            guard let data = stringMessage.data(using: .utf8) else {
                return .message(.unsupported)
            }
            if stringMessage.contains("status") {
                return checkSubscription(from: data)
            } else if stringMessage.contains("type") {
                return decode(from: data)
            } else {
                return .message(.unsupported)
            }
        default:
            return .message(.unsupported)
        }
    }
    
    private static func checkSubscription(from data: Data) -> MessageParsingResult {
        do {
            let parsedResult = try JSONDecoder().decode(ConnectionMessage.self, from: data)
            switch parsedResult.messageContent {
            case .subscribedSuccessfully:
                return .subscription(.subscribedSuccessfully)
            case .failedToSubscribe:
                return .subscription(.failedToSubscribe)
            default:
                return .message(.unsupported)
            }
        } catch {
            return .error(.decodingFailed)
        }
    }
    
    private static func decode(from data: Data) -> MessageParsingResult {
        do {
            let deserializedResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let entityType = deserializedResult?["type"] as? String
            switch entityType {
            case "ticker":
                let tickerEntity = try WebSocketResponseData<WebSocketTicker>.decode(data: data)
                return .message(.ticker(tickerEntity.toDomain()))
            case "transaction":
                let transactionEntities = try WebSocketResponseData<WebSocketTransactionHistory>.decode(data: data)
                let transactionDTOs = transactionEntities.transactions?.map { $0.toDomain() } ?? []
                return .message(.transaction(transactionDTOs))
            case "orderbookdepth":
                let orderBookEntity = try WebSocketResponseData<WebSocketOrderBook>.decode(data: data)
                return .message(.orderBook(orderBookEntity.toDomain()))
            default:
                return .message(.unsupported)
            }
        } catch {
            return .error(.decodingFailed)
        }
    }
}

private struct WebSocketResponseData<Entity: Decodable> {
    struct CommonResponse: Decodable {
        let status: String
        let content: Entity
    }
    
    static func decode(data: Data) throws -> Entity {
        let result = try JSONDecoder().decode(CommonResponse.self, from: data)
        return result.content
    }
}
