//
//  TickerTableViewDataSource.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/24.
//

import UIKit

final class TickerTableViewDataSource: NSObject {
    private var tickers: [TickerDTO] = []
    private var tickerIndexFinder: [String: Int] = [:]
    
    func configure(tickers: [TickerDTO]) {
        self.tickers = tickers
        for index in tickers.indices {
            guard let symbol = tickers[index].symbol else {
                continue
            }
            self.tickerIndexFinder[symbol] = index
        }
    }
    
    func update(by ticker: TickerDTO) -> Int? {
        guard let symbol = ticker.symbol, let index = self.tickerIndexFinder[symbol] else {
            return nil
        }
        self.tickers[index] = ticker
        return index
    }
    
    func findSymbol(by index: Int) -> String? {
        return tickers[index].symbol
    }
}

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
