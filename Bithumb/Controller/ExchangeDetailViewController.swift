//
//  ExchangeDetailViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip

final class ExchangeDetailViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet private weak var headerView: ExchangeDetailHeaderView!
    private var symbol: String?
    private let repository: Repositoryable = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository.register(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestRestTickerAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        repository.execute(request: .disconnect)
    }
    
    func register(symbol: String?) {
        self.symbol = symbol
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let orderBookViewController = storyboard?.instantiateViewController(withIdentifier: "OrderBookViewController") as? OrderBookViewController else {
            return []
        }
        
        orderBookViewController.register(symbol: symbol)
        
        let chartViewController = ChartViewController()
        let transactionViewController = TransactionViewController()
        
        return [orderBookViewController, chartViewController, transactionViewController]
    }
}

extension ExchangeDetailViewController {
    private func requestRestTickerAPI() {
        guard let symbol = symbol else {
            return
        }
        
        let currencies = symbol.split(separator: "_").map { String($0) }
        guard let orderCurrency = currencies.first, let paymentCurrency = currencies.last else {
            return
        }
        
        let tickerRequest = TickerRequest.lookUp(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
        repository.execute(request: tickerRequest) { [weak self] result in
            switch result {
            case .success(let tickers):
                DispatchQueue.main.async {
                    self?.headerView.configure(by: tickers.first)
                }
                self?.requestWebSocketTickerAPI(symbol: symbol)
            case .failure(_):
                break
            }
        }
    }
    
    private func requestWebSocketTickerAPI(symbol: String) {
        repository.execute(request: .connect(target: .bitumbPublic))
        repository.execute(request: .send(message: .ticker(symbols: [symbol])))
    }
}

extension ExchangeDetailViewController: WebSocketDelegate {
    func didReceive(_ connectionEvent: WebSocketConnectionEvent) {
        
    }
    
    func didReceive(_ messageEvent: WebSocketResponseMessage) {
        switch messageEvent {
        case .ticker(let tickerDTO):
            DispatchQueue.main.async {
                self.headerView.configure(by: tickerDTO)
            }
        default:
            break
        }
    }
    
    func didReceive(_ subscriptionEvent: WebSocketSubscriptionEvent) {
        
    }
    
    func didReceive(_ error: WebSocketCommonError) {
        
    }
    
    
}
