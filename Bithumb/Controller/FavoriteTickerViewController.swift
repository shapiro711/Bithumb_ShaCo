//
//  FavoriteTickerViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/29.
//

import UIKit
import XLPagerTabStrip

class FavoriteTickerViewController: UIViewController {
    @IBOutlet private weak var tickerTableView: UITableView!
    private let repository: Repositoryable = Repository()
    private let tickerTableViewDataSource = TickerTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
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
}

extension FavoriteTickerViewController {
    private func setUpTableView() {
        tickerTableView.dataSource = tickerTableViewDataSource
        tickerTableView.delegate = self
        tickerTableView.register(TickerTableViewCell.self, forCellReuseIdentifier: TickerTableViewCell.identifier)
    }
}

extension FavoriteTickerViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "관심")
    }
}

extension FavoriteTickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exchangeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ExchangeDetailViewController") as? ExchangeDetailViewController else {
            return
        }
        
        let symbol = tickerTableViewDataSource.findSymbol(by: indexPath.row)
        exchangeDetailViewController.register(symbol: symbol)
        
        navigationController?.pushViewController(exchangeDetailViewController, animated: true)
    }
}

extension FavoriteTickerViewController {
    private func requestRestTickerAPI() {
        let favoriteCoinSymbols = bringFavoriteCoinSymbols()
        var requestResults: [Result<[TickerDTO], RestError>] = []
        let dispatchGroup = DispatchGroup()
        
        let tickerRequests = favoriteCoinSymbols.compactMap { (symbol: String) -> TickerRequest? in
            let currencies = symbol.split(separator: "_").map { String($0) }
            guard let orderCurrency = currencies.first, let paymentCurrency = currencies.last else {
                return nil
            }
            
            return TickerRequest.lookUp(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
        }
    
        tickerRequests.forEach {
            dispatchGroup.enter()
            repository.execute(request: $0) { result in
                requestResults.append(result)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .global()) { [weak self] in
            var favoriteCoinTickers: [TickerDTO] = []
            requestResults.forEach { result in
                switch result {
                case .success(let tickers):
                    favoriteCoinTickers.append(contentsOf: tickers)
                case .failure(_):
                    break
                }
            }
            self?.tickerTableViewDataSource.configure(tickers: favoriteCoinTickers)
            DispatchQueue.main.async {
                self?.tickerTableView.reloadData()
            }
            self?.requestWebSocketTickerAPI(symbols: favoriteCoinSymbols)
        }
    }
    
    private func requestWebSocketTickerAPI(symbols: [String]) {
        repository.execute(request: .connect(target: .bitumbPublic))
        repository.execute(request: .send(message: .ticker(symbols: symbols)))
    }
    
    private func bringFavoriteCoinSymbols() -> [String] {
        guard let favoriteCoinSymbols = UserDefaults.standard.array(forKey: "favoriteCoinSymbols") as? [String] else {
            return []
        }
        return favoriteCoinSymbols
    }
}

extension FavoriteTickerViewController: WebSocketDelegate {
    func didReceive(_ connectionEvent: WebSocketConnectionEvent) {
        
    }
    
    func didReceive(_ messageEvent: WebSocketResponseMessage) {
        switch messageEvent {
        case .ticker(let tickerDTO):
            guard let index = tickerTableViewDataSource.update(by: tickerDTO) else {
                return
            }
            DispatchQueue.main.async {
                self.tickerTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
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
