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
    
    func update(by orderBookDepth: OrderBookDepthDTO) {
        updateAskBook(using: orderBookDepth.asks)
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

extension OrderBookTableViewDataSource {
    private func updateAskBook(using newAskBook: [OrderBookDepthDTO.OrderBookData]?) {
        let newAskBook = newAskBook?.sorted { $0.price ?? 0 > $1.price ?? 0 } ?? []
        
        var mergedAskBook = [OrderBookDepthDTO.OrderBookData]()
        
        var oldAskBookIndex = 0
        var newAskBookIndex = 0
        
        while newAskBookIndex < newAskBook.count && oldAskBookIndex < asks.count {
            guard let newAskPrice = newAskBook[newAskBookIndex].price else {
                newAskBookIndex += 1
                continue
            }
            guard let oldAskPrice = asks[oldAskBookIndex].price else {
                oldAskBookIndex += 1
                continue
            }
            
            if newAskPrice > oldAskPrice {
                if newAskBook[newAskBookIndex].quantity == 0 {
                    newAskBookIndex += 1
                    continue
                }
                mergedAskBook.append(newAskBook[newAskBookIndex])
                newAskBookIndex += 1
            } else if newAskPrice == oldAskPrice {
                if newAskBook[newAskBookIndex].quantity != 0 {
                    mergedAskBook.append(newAskBook[newAskBookIndex])
                }
                newAskBookIndex += 1
                oldAskBookIndex += 1
            } else {
                mergedAskBook.append(asks[oldAskBookIndex])
                oldAskBookIndex += 1
            }
        }
        
        while newAskBookIndex < newAskBook.count {
            mergedAskBook.append(newAskBook[newAskBookIndex])
            newAskBookIndex += 1
        }
        
        while oldAskBookIndex < asks.count {
            mergedAskBook.append(asks[oldAskBookIndex])
            oldAskBookIndex += 1
        }
        
        if mergedAskBook.count > 30 {
            asks = mergedAskBook.reversed().prefix(30).reversed()
        } else {
            asks = mergedAskBook
        }
    }
}
