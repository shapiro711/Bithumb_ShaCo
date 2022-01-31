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
        setUpBarChartView()
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
        candlestickChartView.xAxis.setLabelCount(4, force: false)
        candlestickChartView.legend.enabled = false
        candlestickChartView.pinchZoomEnabled = true
        candlestickChartView.scaleXEnabled = true
        candlestickChartView.scaleYEnabled = true
        candlestickChartView.doubleTapToZoomEnabled = false
    }
    
    private func setUpBarChartView() {
        barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.setLabelCount(4, force: false)
        barChartView.leftAxis.enabled = false
        barChartView.pinchZoomEnabled = true
        barChartView.scaleXEnabled = true
        barChartView.scaleYEnabled = true
        barChartView.doubleTapToZoomEnabled = false
        barChartView.rightAxis.enabled = true
        barChartView.rightAxis.axisMinimum = 0
        barChartView.leftAxis.axisMinimum = 0
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
                self?.drawCandlestickChart(by: candlesticks, chartInterval: chartInterval)
                self?.drawBarChart(by: candlesticks, chartInterval: chartInterval)
            case .failure(let error):
                UIAlertController.showAlert(about: error, on: self)
            }
        }
    }
}

extension ChartViewController {
    private func drawCandlestickChart(by data: [CandlestickDTO], chartInterval: ChartInterval) {
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
        chartDataSet.neutralColor = .systemRed
        chartDataSet.increasingFilled = true
        chartDataSet.shadowColorSameAsCandle = true
        chartDataSet.drawValuesEnabled = false
        
        let chartData = CandleChartData(dataSet: chartDataSet)
        
        DispatchQueue.main.async {
            self.candlestickChartView.data = chartData
            self.candlestickChartView.fitScreen()
            
            if let openPrice = data.last?.initialPrice, let closingPrice = data.last?.finalPrice {
                self.candlestickChartView.zoomToCenter(scaleX: 80, scaleY: 20)
                self.candlestickChartView.moveViewTo(xValue: Double(data.count - 1), yValue: (openPrice + closingPrice) / 2, axis: .right)
            }
            
            let dateFormatter = self.generateDateFormatter(by: chartInterval)
            self.candlestickChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map { dateFormatter.string(from: $0.date) })
        }
    }
    
    private func drawBarChart(by data: [CandlestickDTO], chartInterval: ChartInterval) {
        var chartEntries = [BarChartDataEntry]()
        for index in data.indices {
            let entry = BarChartDataEntry(x: Double(index), y: data[index].volume ?? 0)
            chartEntries.append(entry)
        }
        
        let chartDataSet = BarChartDataSet(entries: chartEntries, label: nil)
        let chartColors = data.map { (candlestick: CandlestickDTO) -> UIColor in
            guard let openPrice = candlestick.initialPrice,
                  let closePrice = candlestick.finalPrice else {
                      return .label
                  }
            if openPrice > closePrice {
                return .systemBlue
            } else if openPrice < closePrice {
                return .systemRed
            } else {
                return .systemRed
            }
        }
        chartDataSet.colors = chartColors
        chartDataSet.drawValuesEnabled = false
        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        DispatchQueue.main.async {
            self.barChartView.data = chartData
            self.barChartView.fitScreen()
            
            if let volume = data.last?.volume {
                self.barChartView.zoomToCenter(scaleX: 80, scaleY: 20)
                self.barChartView.moveViewTo(xValue: Double(data.count - 1), yValue: volume, axis: .right)
            }
            
            let dateFormatter = self.generateDateFormatter(by: chartInterval)
            self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map { dateFormatter.string(from: $0.date) })
        }
    }
    
    private func generateDateFormatter(by chartInterval: ChartInterval) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch chartInterval {
        case .oneMinute:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .tenMinutes:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .thirtyMinutes:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .oneHour:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .twentyFourHours:
            dateFormatter.dateFormat = "yyyy-MM-dd"
        default:
            dateFormatter.dateFormat = "dd-HH:mm"
        }
        
        return dateFormatter
    }
}
