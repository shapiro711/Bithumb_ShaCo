//
//  ExchangeViewContorller.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/25.
//

import UIKit
import XLPagerTabStrip

enum TickerCriteria: String {
    case krw = "KRW"
    
    var reqeustBasedOnCriteria: TickerRequest {
        switch self {
        case .krw:
            return TickerRequest.lookUpAll(paymentCurrency: "KRW")
        }
    }
}

final class ExchangeViewContorller: ButtonBarPagerTabStripViewController {
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let krwTickerViewController = storyboard?.instantiateViewController(withIdentifier: "TickerViewController") as? TickerViewController else {
            return []
        }
        
        krwTickerViewController.register(tickerCriteria: .krw)
        
        return [krwTickerViewController]
    }
}
