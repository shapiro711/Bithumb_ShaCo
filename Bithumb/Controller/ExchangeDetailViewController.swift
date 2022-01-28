//
//  ExchangeDetailViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip

protocol ClosingPriceReceivable: AnyObject {
    func didReceive(previousDayClosingPrice: Double?)
}

enum ClosingPriceReceiveStatus {
    case notReceived
    case received
}

final class ExchangeDetailViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet private weak var headerView: ExchangeDetailHeaderView!
    private var symbol: String?
    private let repository: Repositoryable = Repository()
    private var closingPriceReceivers: [ClosingPriceReceivable] = []
    
    override func viewDidLoad() {
        setUpButtonBar()
        super.viewDidLoad()
        repository.register(delegate: self)
        setUpNavigationBar()
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
        guard let orderBookViewController = storyboard?.instantiateViewController(withIdentifier: "OrderBookViewController") as? OrderBookViewController,
              let transactionViewController = storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as? TransactionViewController,
              let chartViewController = storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController else {
                  return []
              }
        
        orderBookViewController.register(symbol: symbol)
        transactionViewController.register(symbol: symbol)
        chartViewController.register(symbol: symbol)
        
        closingPriceReceivers.append(orderBookViewController)
        closingPriceReceivers.append(transactionViewController)
        
        return [orderBookViewController, chartViewController, transactionViewController]
    }
}

extension ExchangeDetailViewController {
    private func setUpButtonBar() {
        settings.style.buttonBarItemBackgroundColor = .systemBackground
        settings.style.buttonBarItemTitleColor = .label
        settings.style.selectedBarBackgroundColor = UIColor(red: 1, green: 0.6, blue: 0.2, alpha: 1)
        settings.style.buttonBarMinimumLineSpacing = 40
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = symbol?.replacingOccurrences(of: String.underScore, with: String.slash)
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
                self?.closingPriceReceivers.forEach { $0.didReceive(previousDayClosingPrice: tickers.first?.data.previousDayClosingPrice) }
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
            closingPriceReceivers.forEach { $0.didReceive(previousDayClosingPrice: tickerDTO.data.previousDayClosingPrice) }
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
