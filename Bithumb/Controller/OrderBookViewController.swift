//
//  OrderBookViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip

final class OrderBookViewController: UIViewController {
    @IBOutlet private weak var orderBookTableView: UITableView!
    private let orderBookTableViewDataSource = OrderBookTableViewDataSource()
    private let repository: Repositoryable = Repository()
    private var symbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestRestOrderBookAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func register(symbol: String?) {
        self.symbol = symbol
    }
}

extension OrderBookViewController {
    private func setUpTableView() {
        orderBookTableView.dataSource = orderBookTableViewDataSource
        orderBookTableView.register(OrderBookAskTableViewCell.self, forCellReuseIdentifier: OrderBookAskTableViewCell.identifier)
        orderBookTableView.register(OrderBookBidTableViewCell.self, forCellReuseIdentifier: OrderBookBidTableViewCell.identifier)
        orderBookTableView.separatorStyle = .none
    }
}

extension OrderBookViewController {
    private func requestRestOrderBookAPI() {
        guard let symbol = symbol else {
            return
        }
        
        let currencies = symbol.split(separator: "_").map { String($0) }
        
        guard let orderCurrency = currencies.first, let paymentCurrency = currencies.last else {
            return
        }
        
        let orderBookRequest = OrderBookRequest.lookUp(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
        repository.execute(request: orderBookRequest) { [weak self] result in
            switch result {
            case .success(let orderBookDepth):
                self?.orderBookTableViewDataSource.configure(orderBookDepth: orderBookDepth)
                DispatchQueue.main.async {
                    self?.orderBookTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func requestWebSocketOrderBookAPI() {
        
    }
}

extension OrderBookViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "호가")
    }
}
