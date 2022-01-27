//
//  TransactionViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip
import SpreadsheetView

final class TransactionViewController: UIViewController {
    private let spreadsheetView = SpreadsheetView()
    private let spreadsheetDataSource = TransactionSpreadsheetDataSource()
    private var symbol: String?
    private let repository: Repositoryable = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildHierachy()
        laysOutConstraint()
        setUpSpreadsheetView()
        repository.register(delegate: self)
    }
    
    func register(symbol: String?) {
        self.symbol = symbol
    }
}

extension TransactionViewController {
    private func buildHierachy() {
        view.addSubview(spreadsheetView)
    }
    
    private func laysOutConstraint() {        
        NSLayoutConstraint.activate([
            spreadsheetView.topAnchor.constraint(equalTo: view.topAnchor),
            spreadsheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spreadsheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spreadsheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpSpreadsheetView() {
        spreadsheetView.translatesAutoresizingMaskIntoConstraints = false
        spreadsheetView.dataSource = spreadsheetDataSource
        spreadsheetView.showsHorizontalScrollIndicator = false
        spreadsheetView.bounces = false
        spreadsheetView.allowsSelection = false
        spreadsheetView.isDirectionalLockEnabled = true
    }
}

extension TransactionViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "시세")
    }
}

extension TransactionViewController {
    private func requestRestTransactionAPI() {
        guard let symbol = symbol else {
            return
        }
        
        let currencies = symbol.split(separator: "_").map { String($0) }
        guard let orderCurrency = currencies.first, let paymentCurrency = currencies.last else {
            return
        }
        
        let transactionRequest = TransactionRequest.lookUp(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
        repository.execute(request: transactionRequest) { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.spreadsheetDataSource.configure(by: transactions)
                DispatchQueue.main.async {
                    self?.spreadsheetView.reloadData()
                }
                self?.requestWebSocketTransactionAPI(symbol: symbol)
            case .failure(_):
                break
            }
        }
    }
    
    private func requestWebSocketTransactionAPI(symbol: String) {
        repository.execute(request: .connect(target: .bitumbPublic))
        repository.execute(request: .send(message: .transaction(symbols: [symbol])))
    }
}

extension TransactionViewController: WebSocketDelegate {
    func didReceive(_ connectionEvent: WebSocketConnectionEvent) {
        
    }
    
    func didReceive(_ messageEvent: WebSocketResponseMessage) {
        switch messageEvent {
        case .transaction(let transactions):
            spreadsheetDataSource.update(by: transactions)
            DispatchQueue.main.async {
                self.spreadsheetView.reloadData()
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

extension TransactionViewController: ClosingPriceReceivable {
    func didReceive(previousDayClosingPrice: Double?) {
        
    }
}
