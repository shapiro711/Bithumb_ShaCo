//
//  OrderBookTableViewDataSource.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/26.
//

import UIKit

final class OrderBookTableViewDataSource: NSObject {
    //MARK: Properties
    private var asks: [OrderBookDepthDTO.OrderBookData] = []
    private var bids: [OrderBookDepthDTO.OrderBookData] = []
    private var previousDayClosingPrice: Double?
    
    //MARK: Interface
    func configure(orderBookDepth: OrderBookDepthDTO) {
        self.asks = orderBookDepth.asks?.reversed() ?? []
        self.bids = orderBookDepth.bids ?? []
    }
    
    func update(by orderBookDepth: OrderBookDepthDTO) {
        let newAsks = self.updateOrderBook(using: orderBookDepth.asks, oldOrderBook: self.asks)
        let newBids = self.updateOrderBook(using: orderBookDepth.bids, oldOrderBook: self.bids)
        
        if newAsks.count > 30 {
            self.asks = newAsks.reversed().prefix(30).reversed()
        } else {
            self.asks = newAsks
        }
        
        if newBids.count > 30 {
            self.bids = Array(newBids.prefix(30))
        } else {
            self.bids = newBids
        }
    }
    
    func receive(previousDayClosingPrice: Double?) {
        self.previousDayClosingPrice = previousDayClosingPrice
    }
}

//MARK: - Conform to UITableViewDataSource
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
            let fluctuation = calculateFluctuation(orderPrice: askOrder.price)
            cell.configure(by: askOrder, fluctuation: fluctuation)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderBookBidTableViewCell.identifier, for: indexPath) as? OrderBookBidTableViewCell else {
                return UITableViewCell()
            }
            
            let bidOrder = bids[indexPath.row]
            let fluctuation = calculateFluctuation(orderPrice: bidOrder.price)
            cell.configure(by: bidOrder, fluctuation: fluctuation)
            
            return cell
        }
    }
}

//MARK: - Update OrderBook Logic
extension OrderBookTableViewDataSource {
    private func updateOrderBook(using newOrderBook: [OrderBookDepthDTO.OrderBookData]?, oldOrderBook: [OrderBookDepthDTO.OrderBookData]) -> [OrderBookDepthDTO.OrderBookData] {
        let newOrderBook = newOrderBook?.sorted { $0.price ?? 0 > $1.price ?? 0 } ?? []
        
        var mergedBook = [OrderBookDepthDTO.OrderBookData]()
        
        var oldBookIndex = 0
        var newBookIndex = 0
        
        while newBookIndex < newOrderBook.count && oldBookIndex < oldOrderBook.count {
            guard let newOrderPrice = newOrderBook[newBookIndex].price else {
                newBookIndex += 1
                continue
            }
            guard let oldOrderPrice = oldOrderBook[oldBookIndex].price else {
                oldBookIndex += 1
                continue
            }
            
            if newOrderPrice > oldOrderPrice {
                if newOrderBook[newBookIndex].quantity == 0 {
                    newBookIndex += 1
                    continue
                }
                mergedBook.append(newOrderBook[newBookIndex])
                newBookIndex += 1
            } else if newOrderPrice == oldOrderPrice {
                if newOrderBook[newBookIndex].quantity != 0 {
                    mergedBook.append(newOrderBook[newBookIndex])
                }
                newBookIndex += 1
                oldBookIndex += 1
            } else {
                mergedBook.append(oldOrderBook[oldBookIndex])
                oldBookIndex += 1
            }
        }
        
        while newBookIndex < newOrderBook.count {
            mergedBook.append(newOrderBook[newBookIndex])
            newBookIndex += 1
        }
        
        while oldBookIndex < oldOrderBook.count {
            mergedBook.append(oldOrderBook[oldBookIndex])
            oldBookIndex += 1
        }
        
        return mergedBook
    }
    
    private func calculateFluctuation(orderPrice: Double?) -> Double? {
        guard let orderPrice = orderPrice, let previousDayClosingPrice = previousDayClosingPrice else {
            return nil
        }
        
        if previousDayClosingPrice == 0 {
            return 1
        } else {
            return orderPrice / previousDayClosingPrice
        }
    }
}
