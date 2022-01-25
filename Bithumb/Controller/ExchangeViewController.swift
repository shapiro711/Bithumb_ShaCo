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
    case btc = "BTC"
    case favorites = "관심"
    
    var reqeustBasedOnCriteria: TickerRequest {
        switch self {
        case .krw:
            return TickerRequest.lookUpAll(paymentCurrency: self.rawValue)
        case .btc:
            return TickerRequest.lookUpAll(paymentCurrency: self.rawValue)
        case .favorites:
            return TickerRequest.lookUpAll(paymentCurrency: "KRW")
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

final class ExchangeViewContorller: SegmentedPagerTabStripViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let krwTickerViewController = storyboard?.instantiateViewController(withIdentifier: "TickerViewController") as? TickerViewController,
              let btcTickerViewController = storyboard?.instantiateViewController(withIdentifier: "TickerViewController") as? TickerViewController,
              let favoritesTickerViewController = storyboard?.instantiateViewController(withIdentifier: "TickerViewController") as? TickerViewController else {
                  return []
              }
        
        krwTickerViewController.register(tickerCriteria: .krw)
        btcTickerViewController.register(tickerCriteria: .btc)
        favoritesTickerViewController.register(tickerCriteria: .favorites)
        
        return [krwTickerViewController, btcTickerViewController, favoritesTickerViewController]
    }
}
