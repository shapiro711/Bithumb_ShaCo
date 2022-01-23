//
//  TickerTableViewDataSource.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/24.
//

import UIKit

final class TickerTableViewDataSource: NSObject {
    private var tickers: [TickerDTO] = []
    
    func configure(tickers: [TickerDTO]) {
        self.tickers = tickers
    }
}

extension TickerTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
