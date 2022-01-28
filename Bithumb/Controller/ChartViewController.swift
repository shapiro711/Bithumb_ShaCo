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
    private let repository: Repositoryable = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentControl()
        setUpCandlestickChartView()
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
        chartIntervalSegmentedControl.addTarget(self, action: #selector(touchUpSegmentedControl), for: .valueChanged)
    }
    
    @objc private func touchUpSegmentedControl() {
        reqeustRestCandlestickAPI()
    }
    
    private func setUpCandlestickChartView() {
        candlestickChartView.xAxis.labelPosition = .bottom
        candlestickChartView.leftAxis.enabled = false
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
        guard let chartInterval = ChartInterval(interval: interval), let symbol = symbol else {
            return
        }
        
        let currencies = symbol.split(separator: "_").map { String($0) }
        guard let orderCurrency = currencies.first, let paymentCurrency = currencies.last else {
            return
        }
        
        let candlestickRequest = CandlestickRequest.lookUp(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency, chartIntervals: chartInterval)
        repository.execute(request: candlestickRequest) { [weak self] result in
            switch result {
            case .success(let candlesticks):
                DispatchQueue.main.async {
                    self?.setUpCandlestickChart(by: candlesticks)
                }
            case .failure(_):
                break
            }
        }
    }
}

extension ChartViewController {
    private func setUpCandlestickChart(by data: [CandlestickDTO]) {
        var chartEntries = [CandleChartDataEntry]()
        for index in data.indices {
            let entry = CandleChartDataEntry(x: Double(index),
                                             shadowH: data[index].highPrice ?? 0,
                                             shadowL: data[index].lowPrice ?? 0,
                                             open: data[index].initialPrice ?? 0,
                                             close: data[index].finalPrice ?? 0)
            chartEntries.append(entry)
        }
        
        let chartDataSet = CandleChartDataSet(entries: chartEntries, label: nil)
        chartDataSet.increasingColor = .systemRed
        chartDataSet.decreasingColor = .systemBlue
        chartDataSet.increasingFilled = true
        chartDataSet.shadowColorSameAsCandle = true
        chartDataSet.drawValuesEnabled = false
        
        let chartData = CandleChartData(dataSet: chartDataSet)
        
        candlestickChartView.data = chartData
        candlestickChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map { $0.date.description })
        
        if let lastEntry = chartEntries.last {
            let pixel = candlestickChartView.getPosition(entry: lastEntry, axis: .right)
            candlestickChartView.zoomToCenter(scaleX: 0, scaleY: 0)
            candlestickChartView.zoom(scaleX: 150, scaleY: 1, x: pixel.x, y: pixel.y)
        }
    }
}
