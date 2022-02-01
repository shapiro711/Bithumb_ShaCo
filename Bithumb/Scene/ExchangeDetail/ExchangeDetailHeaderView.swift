//
//  ExchangeDetailHeaderView.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit

final class ExchangeDetailHeaderView: UIView {
    //MARK: Properties
    private let tickerInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let fluctuationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .left
        return label
    }()
    private let fluctatedRateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    private let fluctatedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildHierachy()
        laysOutConstraints()
    }
    
    func configure(by tickerInformation: TickerDTO?) {
        guard let tickerInformation = tickerInformation else {
            currentPriceLabel.text = "-"
            fluctatedPriceLabel.text = "-"
            fluctatedRateLabel.text = "-"
            return
        }
        
        currentPriceLabel.text = tickerInformation.formattedCurrentPrice
        fluctatedPriceLabel.text = tickerInformation.formattedAccurateFluctuation
        fluctatedRateLabel.text = generateArrow(by: tickerInformation.data.rateOfChange) + tickerInformation.formattedRateOfChange
        
        paint(by: tickerInformation.data.rateOfChange)
    }
}

//MARK: - SetUp UI
extension ExchangeDetailHeaderView {
    private func buildHierachy() {
        addSubview(tickerInformationStackView)
        
        tickerInformationStackView.addArrangedSubview(currentPriceLabel)
        tickerInformationStackView.addArrangedSubview(fluctuationStackView)
        
        fluctuationStackView.addArrangedSubview(fluctatedPriceLabel)
        fluctuationStackView.addArrangedSubview(fluctatedRateLabel)
    }
    
    private func laysOutConstraints() {
        NSLayoutConstraint.activate([
            tickerInformationStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tickerInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        ])
    }
    
    private func paint(by fluctuation: Double?) {
        currentPriceLabel.textColor = .label
        fluctatedRateLabel.textColor = .label
        fluctatedPriceLabel.textColor = .label
        
        guard let fluctuation = fluctuation else {
            return
        }
        
        if fluctuation > 0 {
            currentPriceLabel.textColor = .systemRed
            fluctatedRateLabel.textColor = .systemRed
            fluctatedPriceLabel.textColor = .systemRed
        } else if fluctuation < 0 {
            currentPriceLabel.textColor = .systemBlue
            fluctatedRateLabel.textColor = .systemBlue
            fluctatedPriceLabel.textColor = .systemBlue
        }
    }
    
    private func generateArrow(by fluctuation: Double?) -> String {
        guard let fluctuation = fluctuation, fluctuation != 0 else {
            return ""
        }
        
        if fluctuation > 0 {
            return "▲"
        } else {
            return "▼"
        }
    }
}
