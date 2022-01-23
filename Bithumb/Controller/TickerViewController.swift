//
//  TickerViewController.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/12.
//

import UIKit

final class TickerViewController: UIViewController {
    @IBOutlet private weak var tickerTableView: UITableView!
    private let tickerTableViewDataSource = TickerTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
}

extension TickerViewController {
    private func setUpTableView() {
        tickerTableView.dataSource = tickerTableViewDataSource
    }
}
