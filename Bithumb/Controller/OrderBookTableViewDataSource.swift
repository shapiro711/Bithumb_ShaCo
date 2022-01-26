//
//  OrderBookTableViewDataSource.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/26.
//

import UIKit

final class OrderBookTableViewDataSource: NSObject {
    private var asks: [OrderBookDepthDTO.OrderBookData] = []
    private var bids: [OrderBookDepthDTO.OrderBookData] = []
    
    func configure(orderBookDepth: OrderBookDepthDTO) {
        asks = orderBookDepth.asks?.reversed() ?? []
        bids = orderBookDepth.bids ?? []
    }
}

extension OrderBookTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return asks.count
        } else {
            return bids.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderBookAskTableViewCell.identifier, for: indexPath) as? OrderBookAskTableViewCell else {
                return UITableViewCell()
            }
            let askOrder = asks[indexPath.row]
            cell.configure(by: askOrder)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderBookBidTableViewCell.identifier, for: indexPath) as? OrderBookBidTableViewCell else {
                      return UITableViewCell()
                  }
            
            let bidOrder = bids[indexPath.row]
            cell.configure(by: bidOrder)
            
            return cell
        }
    }
}
