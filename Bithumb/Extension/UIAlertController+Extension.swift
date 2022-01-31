//
//  UIAlertController+Extension.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/31.
//

import UIKit

extension UIAlertController {
    static func showAlert(about event: WebSocketConnectionEvent, on viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            switch event {
            case .failedToConnect, .unintentionalDisconnection:
                alertController.title = "네트워크 오류 발생"
                alertController.message = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
                let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(alertAction)
            default:
                return
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showAlert(about event: WebSocketSubscriptionEvent, on viewController: UIViewController) {
        guard case .failedToSubscribe = event else {
            return
        }
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alertController.title = "네트워크 오류 발생"
            alertController.message = "데이터를 받아오는데 실패하였습니다. 문제가 지속되는 경우 문의를 남겨주세요."
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(alertAction)
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showAlert(about error: WebSocketCommonError, on viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(alertAction)
            
            switch error {
            case .urlGeneration, .encodingFailed, .decodingFailed:
                alertController.title = "알 수 없는 오류 발생"
                alertController.message = "알 수 없는 오류가 발생하였습니다. 잠시 후 다시 시도해주세요."
            case .messageError:
                alertController.title = "네트워크 오류 발생"
                alertController.message = "네트워크 통신도중 문제가 발생하였습니다. 잠시 후 다시 시도해주세요."
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showAlert(about error: RestError, on viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(alertAction)
            
            switch error {
            case .urlGeneration, .abnormalResponse, .notExistData, .parsingFailed, .undefined:
                alertController.title = "알 수 없는 오류 발생"
                alertController.message = "알 수 없는 오류가 발생하였습니다. 잠시 후 다시 시도해주세요."
            case .internetProblem:
                alertController.title = "네트워크 오류 발생"
                alertController.message = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
