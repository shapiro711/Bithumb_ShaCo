//
//  TickerTableViewCell.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/24.
//

import UIKit

final class TickerTableViewCell: UITableViewCell {
    static let identifier = String(describing: TickerTableViewCell.self)
    
    private let tickerInformationStackView: UIStackView = {
        let tickerInformationStackView = UIStackView()
        tickerInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        tickerInformationStackView.axis = .horizontal
        tickerInformationStackView.alignment = .firstBaseline
        tickerInformationStackView.distribution = .fill
        tickerInformationStackView.spacing = 8
        return tickerInformationStackView
    }()
    private let identityStackView: UIStackView = {
        let identityStackView = UIStackView()
        identityStackView.axis = .vertical
        identityStackView.alignment = .leading
        return identityStackView
    }()
    private let fluctuationStackView: UIStackView = {
        let fluctuationStackView = UIStackView()
        fluctuationStackView.axis = .vertical
        fluctuationStackView.alignment = .trailing
        return fluctuationStackView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    private let symbolLabel: UILabel = {
        let symbolLabel = UILabel()
        symbolLabel.font = .preferredFont(forTextStyle: .caption1)
        symbolLabel.textColor = .systemGray
        return symbolLabel
    }()
    private let currentPriceLabel: UILabel = {
        let currentPriceLabel = UILabel()
        currentPriceLabel.font = .preferredFont(forTextStyle: .body)
        currentPriceLabel.textAlignment = .right
        return currentPriceLabel
    }()
    private let fluctuatedRateLabel: UILabel = {
        let fluctuatedRateLabel = UILabel()
        fluctuatedRateLabel.font = .preferredFont(forTextStyle: .body)
        return fluctuatedRateLabel
    }()
    private let fluctuatedPriceLabel: UILabel = {
        let fluctuatedPriceLabel = UILabel()
        fluctuatedPriceLabel.font = .preferredFont(forTextStyle: .caption1)
        return fluctuatedPriceLabel
    }()
    private let transactionAmountLabel: UILabel = {
        let transactionAmountLabel = UILabel()
        transactionAmountLabel.font = .preferredFont(forTextStyle: .body)
        return transactionAmountLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierarchy()
        laysOutConstranints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TickerTableViewCell {
    private func buildHierarchy() {
        contentView.addSubview(tickerInformationStackView)
        
        tickerInformationStackView.addArrangedSubview(identityStackView)
        tickerInformationStackView.addArrangedSubview(currentPriceLabel)
        tickerInformationStackView.addArrangedSubview(fluctuationStackView)
        tickerInformationStackView.addArrangedSubview(transactionAmountLabel)
        
        identityStackView.addArrangedSubview(nameLabel)
        identityStackView.addArrangedSubview(symbolLabel)
        
        fluctuationStackView.addArrangedSubview(fluctuatedRateLabel)
        fluctuationStackView.addArrangedSubview(fluctuatedPriceLabel)
    }
    
    private func laysOutConstranints() {
        let margin = 8.0
        NSLayoutConstraint.activate([
            tickerInformationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            tickerInformationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            tickerInformationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            tickerInformationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            
            identityStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            currentPriceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            fluctuationStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15)
        ])
    }
    
    func configure(by tickerInformation: TickerDTO) {
        nameLabel.text = tickerInformation.symbol
        symbolLabel.text = tickerInformation.symbol
        currentPriceLabel.text = tickerInformation.data.currentPrice?.description ?? "-"
        fluctuatedRateLabel.text = tickerInformation.data.rateOfChange?.description ?? "-"
        fluctuatedPriceLabel.text = tickerInformation.data.amountOfChange?.description ?? "-"
        transactionAmountLabel.text = tickerInformation.data.accumulatedTransactionAmount?.description ?? "-"
    }
}
