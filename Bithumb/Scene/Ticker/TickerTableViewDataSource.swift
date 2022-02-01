//
//  TickerTableViewDataSource.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/24.
//

import UIKit

final class TickerTableViewDataSource: NSObject {
    //MARK: Properties
    private var tickers: [TickerDTO] = []
    private var tickerIndexFinder: [String: Int] = [:]
    private var tickerTrends: [PriceTrend] = []
    
    //MARK: Interface
    func configure(tickers: [TickerDTO]) {
        self.tickers = tickers
        for index in tickers.indices {
            guard let symbol = tickers[index].symbol else {
                continue
            }
            self.tickerIndexFinder[symbol] = index
        }
        
        tickerTrends = Array(repeating: .equal, count: tickers.count)
    }
    
    func update(by ticker: TickerDTO) -> Int? {
        guard let symbol = ticker.symbol, let index = self.tickerIndexFinder[symbol] else {
            return nil
        }
        
        if let previousPrice = tickers[index].data.currentPrice, let currentPrice = ticker.data.currentPrice {
            if previousPrice > currentPrice {
                tickerTrends[index] = .down
            } else if previousPrice == currentPrice {
                tickerTrends[index] = .equal
            } else {
                tickerTrends[index] = .up
            }
        } else {
            tickerTrends[index] = .equal
        }
        
        self.tickers[index] = ticker
        
        return index
    }
    
    func findSymbol(by index: Int) -> String? {
        return tickers[index].symbol
    }
    
    func findKoreanName(by index: Int) -> String? {
        return tickers[index].koreanName
    }
    
    func bringTrend(by index: Int) -> PriceTrend {
        return tickerTrends[index]
    }
    
    func resetTrend(by index: Int) {
        tickerTrends[index] = .equal
    }
}

//MARK: - Conform to UITableViewDataSource
extension TickerTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TickerTableViewCell.identifier, for: indexPath) as? TickerTableViewCell else {
            return UITableViewCell()
        }
        let ticker = tickers[indexPath.row]
        cell.configure(by: ticker)
        return cell
    }
}
