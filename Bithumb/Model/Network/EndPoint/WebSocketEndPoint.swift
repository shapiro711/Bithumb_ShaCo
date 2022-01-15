//
//  WebSocketEndPoint.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct WebSocketEndPoint: WebSocketEndPointable {
    var path: PathRepresentable
    var message: SubscribeMessage?
}
