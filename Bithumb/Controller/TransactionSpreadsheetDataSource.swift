//
//  TransactionSpreadsheetDataSource.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/27.
//

import Foundation
import SpreadsheetView

enum PriceTrend {
    case up
    case equal
    case down
}

final class TransactionSpreadsheetDataSource {
    private var transactions: [TransactionDTO] = []
    private var previousDayClosingPrice: Double?
    private let updateQueue = DispatchQueue(label: "TransactionUpdateQueue")
    
    func configure(by transactions: [TransactionDTO]) {
        updateQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            self.transactions = transactions.reversed()
        }
    }
    
    func update(by transactions: [TransactionDTO]) {
        updateQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            var reversedTransactions = Array(transactions.reversed())
            reversedTransactions.append(contentsOf: self.transactions)
            self.transactions = reversedTransactions
        }
    }
    
    func receive(previousDayClosingPrice: Double?) {
        self.previousDayClosingPrice = previousDayClosingPrice
    }
}

extension TransactionSpreadsheetDataSource: SpreadsheetViewDataSource {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return spreadsheetView.frame.width / 4.5
        } else {
            return (spreadsheetView.frame.width - (spreadsheetView.frame.width / 4.5)) / 2.02
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return spreadsheetView.frame.height * 0.07
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return transactions.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let transactionInformation = transactions[indexPath.row]
        
        switch indexPath.column {
        case 0:
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionTimeSpreadsheetCell.identifier, for: indexPath) as? TransactionTimeSpreadsheetCell else {
                return nil
            }
            
            cell.configure(by: transactionInformation)
            return cell
        case 1:
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionPriceSpreadsheetCell.identifier, for: indexPath) as? TransactionPriceSpreadsheetCell else {
                return nil
            }
            
            let priceTrend = caculateTrend(transactionPrice: transactionInformation.price)
            cell.configure(by: transactionInformation, priceTrend: priceTrend)
            return cell
        case 2:
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionQuantityTimeSpreadsheetCell.identifier, for: indexPath) as? TransactionQuantityTimeSpreadsheetCell else {
                return nil
            }
            
            cell.configure(by: transactionInformation)
            return cell
        default:
            return nil
        }
    }
    
    private func caculateTrend(transactionPrice: Double?) -> PriceTrend {
        guard let transactionPrice = transactionPrice,
              let previousDayClosingPrice = previousDayClosingPrice else {
                  return .equal
              }
        
        if transactionPrice > previousDayClosingPrice {
            return .up
        } else if transactionPrice == previousDayClosingPrice {
            return .equal
        } else {
            return .down
        }
    }
}
