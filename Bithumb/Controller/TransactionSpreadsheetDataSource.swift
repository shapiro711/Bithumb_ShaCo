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
        return 123
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        return nil
    }
}
