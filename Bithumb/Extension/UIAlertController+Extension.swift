//
//  UIAlertController+Extension.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/31.
//

import UIKit

extension UIAlertController {
    static func showAlert(about error: WebSocketConnectionEvent, on viewController: UIViewController) {
        let alertController = UIAlertController()
        
        switch error {
        case .failedToConnect, .unintentionalDisconnection:
            alertController.title = "네트워크 오류 발생"
            alertController.message = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요"
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(alertAction)
        default:
            return
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
