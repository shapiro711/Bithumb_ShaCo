//
//  ChartViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit
import XLPagerTabStrip
import Charts

final class ChartViewController: UIViewController {
    @IBOutlet private weak var chartIntervalSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var candlestickChartView: CandleStickChartView!
    @IBOutlet private weak var barChartView: BarChartView!
    private var symbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reqeustRestCandlestickAPI()
    }
    
    func register(symbol: String?) {
        self.symbol = symbol
    }
}

extension ChartViewController {
    private func setUpSegmentControl() {
        chartIntervalSegmentedControl.addTarget(self, action: #selector(touchUpSegmentedControl), for: .touchUpInside)
    }
    
    @objc private func touchUpSegmentedControl() {
        reqeustRestCandlestickAPI()
    }
}

extension ChartViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "차트")
    }
}

extension ChartViewController {
    private func reqeustRestCandlestickAPI() {
        let index = chartIntervalSegmentedControl.selectedSegmentIndex
        let interval = chartIntervalSegmentedControl.titleForSegment(at: index)
        guard let chartInterval = ChartInterval(interval: interval) else {
            return
        }
    }
}
