//
//  ConnectionMessage.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/21.
//

import Foundation

enum StatusCode: String {
    case success = "0000"
    case failure = "5100"
}

enum ConnectionMessageContentType: String {
    case connectedSuccessfully = "Connected Successfully"
    case subscribedSuccessfully = "Filter Registered Successfully"
    case failedToSubscribe = "Invalid Filter Syntax"
    
    var contents: String {
        return self.rawValue
    }
}

struct ConnectionMessage {
    let status: StatusCode?
    let messageContent: ConnectionMessageContentType?
}

extension ConnectionMessage: Decodable {
    enum CodingKeys: String, CodingKey {
        case status
        case messageContent = "resmsg"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? StatusCode(rawValue: values.decode(String.self, forKey: .status))
        messageContent = try? ConnectionMessageContentType(rawValue: values.decode(String.self, forKey: .messageContent))
    }
}
