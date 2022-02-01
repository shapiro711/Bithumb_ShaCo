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
    
    func configure(by transactions: [TransactionDTO]) {
        self.transactions = transactions.reversed()
    }
    
    func update(by transactions: [TransactionDTO]) {
        var reversedTransactions = Array(transactions.reversed())
        reversedTransactions.append(contentsOf: self.transactions)
        self.transactions = reversedTransactions
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
        return transactions.count + 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.row, indexPath.column) {
        case (0, 0):
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionAttributeSpreadSheetCell.identifier, for: indexPath) as? TransactionAttributeSpreadSheetCell else {
                return nil
            }
            
            cell.configure(by: "체결시간")
            return cell
        case (0, 1):
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionAttributeSpreadSheetCell.identifier, for: indexPath) as? TransactionAttributeSpreadSheetCell else {
                return nil
            }
            
            cell.configure(by: "체결가격")
            return cell
        case (0, 2):
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionAttributeSpreadSheetCell.identifier, for: indexPath) as? TransactionAttributeSpreadSheetCell else {
                return nil
            }
            
            cell.configure(by: "체결량")
            return cell
        case (_, 0):
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionTimeSpreadsheetCell.identifier, for: indexPath) as? TransactionTimeSpreadsheetCell else {
                return nil
            }
            
            let transactionInformation = transactions[indexPath.row - 1]
            cell.configure(by: transactionInformation)
            return cell
        case (_, 1):
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionPriceSpreadsheetCell.identifier, for: indexPath) as? TransactionPriceSpreadsheetCell else {
                return nil
            }
            
            let transactionInformation = transactions[indexPath.row - 1]
            let priceTrend = caculateTrend(transactionPrice: transactionInformation.price)
            cell.configure(by: transactionInformation, priceTrend: priceTrend)
            return cell
        case (_, 2):
            guard let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TransactionQuantityTimeSpreadsheetCell.identifier, for: indexPath) as? TransactionQuantityTimeSpreadsheetCell else {
                return nil
            }
            
            let transactionInformation = transactions[indexPath.row - 1]
            cell.configure(by: transactionInformation)
            return cell
        default:
            return nil
        }
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
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
