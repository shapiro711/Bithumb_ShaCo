//
//  TickerViewController.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/12.
//

import UIKit

final class TickerViewController: UIViewController {
    @IBOutlet private weak var tickerTableView: UITableView!
    private let repository: Repositoryable = Repository()
    private let tickerTableViewDataSource = TickerTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        requestRestTickerAPI(paymentCurrency: "KRW")
    }
}

extension TickerViewController {
    private func setUpTableView() {
        tickerTableView.dataSource = tickerTableViewDataSource
        tickerTableView.register(TickerTableViewCell.self, forCellReuseIdentifier: TickerTableViewCell.identifier)
    }
}

extension TickerViewController {
    private func requestRestTickerAPI(paymentCurrency: String) {
        let tickerRequest = TickerRequest.lookUpAll(paymentCurrency: paymentCurrency)
        repository.execute(request: tickerRequest) { [weak self] result in
            switch result {
            case .success(let tickers):
                self?.tickerTableViewDataSource.configure(tickers: tickers)
                DispatchQueue.main.async {
                    self?.tickerTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}
