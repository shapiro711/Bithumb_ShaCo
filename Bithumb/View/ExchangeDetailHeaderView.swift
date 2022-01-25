//
//  ExchangeDetailHeaderView.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/25.
//

import UIKit

final class ExchangeDetailHeaderView: UIView {
    private let tickerInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let fluctuationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .right
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildHierachy()
        laysOutConstraints()
    }
}

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
            tickerInformationStackView.topAnchor.constraint(equalTo: topAnchor),
            tickerInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func configure(by tickerInformation: TickerDTO?) {
        guard let tickerInformation = tickerInformation else {
            currentPriceLabel.text = "-"
            fluctatedRateLabel.text = "-"
            fluctatedPriceLabel.text = "-"
            return
        }
        currentPriceLabel.text = tickerInformation.formattedCurrentPrice
        fluctatedRateLabel.text = tickerInformation.formattedRateOfChange
        fluctatedPriceLabel.text = tickerInformation.formattedAmountOfChange
    }
}

