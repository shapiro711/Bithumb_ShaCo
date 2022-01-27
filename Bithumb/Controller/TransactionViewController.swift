//
//  TransactionViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip
import SpreadsheetView

final class TransactionViewController: UIViewController {
    private let spreadsheetView = SpreadsheetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildHierachy()
        laysOutConstraint()
        setUpSpreadSheetView()
    }
}

extension TransactionViewController {
    private func buildHierachy() {
        view.addSubview(spreadsheetView)
    }
    
    private func laysOutConstraint() {        
        NSLayoutConstraint.activate([
            spreadsheetView.topAnchor.constraint(equalTo: view.topAnchor),
            spreadsheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spreadsheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spreadsheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpSpreadSheetView() {
        spreadsheetView.translatesAutoresizingMaskIntoConstraints = false
        spreadsheetView.dataSource = self
    }
}

extension TransactionViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "시세")
    }
}

extension TransactionViewController: SpreadsheetViewDataSource {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 200
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 55
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 300
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 200
    }
}
