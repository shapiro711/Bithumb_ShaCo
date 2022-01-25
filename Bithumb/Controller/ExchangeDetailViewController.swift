//
//  ExchangeDetailViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip

final class ExchangeDetailViewController: ButtonBarPagerTabStripViewController {
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let orderBookViewController = OrderBookViewController()
        let chartViewController = ChartViewController()
        let transactionViewController = TransactionViewController()
        
        return [orderBookViewController, chartViewController, transactionViewController]
    }
}
