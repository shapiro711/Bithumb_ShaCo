//
//  ExchangeDetailViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip

protocol ClosingPriceObserverable {
    func didReceive(previousDayClosingPrice: Double?)
}

enum ClosingPriceReceiveStatus {
    case notReceived
    case received
}

final class ExchangeDetailViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet private weak var headerView: ExchangeDetailHeaderView!
    private var symbol: String?
    private var koreanName: String?
    private let repository: Repositoryable = Repository()
    private var closingPriceObservers: [ClosingPriceObserverable] = []
    private var isFavorite = false
    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchUpFavoriteButton))
        button.tintColor = .systemOrange
        return button
    }()
    
    override func viewDidLoad() {
        setUpButtonBar()
        super.viewDidLoad()
        repository.register(delegate: self)
        setUpNavigationBar()
        setUpNavigationBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerObserver()
        requestRestTickerAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        repository.execute(request: .disconnect)
    }
    
    func register(symbol: String?) {
        self.symbol = symbol
    }
    
    func register(koreanName: String?) {
        self.koreanName = koreanName
    }
    
    func addObserver(observer: ClosingPriceObserverable) {
        closingPriceObservers.append(observer)
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
        if let koreanName = koreanName, let symbol = symbol {
            navigationItem.title = koreanName +
            " (\(symbol.replacingOccurrences(of: String.underScore, with: String.slash)))"
        }
        navigationItem.setRightBarButton(favoriteButton, animated: false)
    }
    
    private func setUpNavigationBarButton() {
        if let favoriteCoinSymbols = UserDefaults.standard.array(forKey: "favoriteCoinSymbols") as? [String],
           let symbol = symbol,
           favoriteCoinSymbols.contains(symbol) {
            isFavorite = true
            favoriteButton.image = UIImage(systemName: "star.fill")
        } else {
            isFavorite = false
            favoriteButton.image = UIImage(systemName: "star")
        }
    }
    
    @objc private func touchUpFavoriteButton() {
        guard let symbol = symbol else {
            return
        }
        let favoriteCoinSymbolsKey = "favoriteCoinSymbols"
        var favoriteCoinSymbols = UserDefaults.standard.array(forKey: favoriteCoinSymbolsKey) as? [String] ?? []

        if isFavorite {
            isFavorite = false
            favoriteButton.image = UIImage(systemName: "star")
            let index = favoriteCoinSymbols.firstIndex(of: symbol)
            if let index = index {
                favoriteCoinSymbols.remove(at: index)
                UserDefaults.standard.set(favoriteCoinSymbols, forKey: favoriteCoinSymbolsKey)
            }
        } else {
            isFavorite = true
            favoriteButton.image = UIImage(systemName: "star.fill")
            favoriteCoinSymbols.append(symbol)
            UserDefaults.standard.set(favoriteCoinSymbols, forKey: favoriteCoinSymbolsKey)
        }
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
                self?.closingPriceObservers.forEach { $0.didReceive(previousDayClosingPrice: tickers.first?.data.previousDayClosingPrice) }
                DispatchQueue.main.async {
                    self?.headerView.configure(by: tickers.first)
                }
                self?.requestWebSocketTickerAPI(symbol: symbol)
            case .failure(let error):
                UIAlertController.showAlert(about: error, on: self)
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
        UIAlertController.showAlert(about: connectionEvent, on: self)
    }
    
    func didReceive(_ messageEvent: WebSocketResponseMessage) {
        switch messageEvent {
        case .ticker(let tickerDTO):
            closingPriceObservers.forEach { $0.didReceive(previousDayClosingPrice: tickerDTO.data.previousDayClosingPrice) }
            DispatchQueue.main.async {
                self.headerView.configure(by: tickerDTO)
            }
        default:
            break
        }
    }
    
    func didReceive(_ subscriptionEvent: WebSocketSubscriptionEvent) {
        UIAlertController.showAlert(about: subscriptionEvent, on: self)
    }
    
    func didReceive(_ error: WebSocketCommonError) {
        UIAlertController.showAlert(about: error, on: self)
    }
}

extension ExchangeDetailViewController: AppLifeCycleOserverable {
    func receiveForegoundNotification() {
        requestRestTickerAPI()
    }
    
    func receiveBackgroundNotification() {
        repository.execute(request: .disconnect)
    }
}
