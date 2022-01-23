//
//  TickerTableViewCell.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/24.
//

import UIKit

final class TickerTableViewCell: UITableViewCell {
    private let tickerInformationStackView: UIStackView = {
        let tickerInformationStackView = UIStackView()
        tickerInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        tickerInformationStackView.axis = .horizontal
        tickerInformationStackView.alignment = .firstBaseline
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
        nameLabel.font = .preferredFont(forTextStyle: .title2)
        return nameLabel
    }()
    private let symbolLabel: UILabel = {
        let symbolLabel = UILabel()
        symbolLabel.font = .preferredFont(forTextStyle: .title3)
        symbolLabel.textColor = .systemGray
        return symbolLabel
    }()
    private let currentPriceLabel: UILabel = {
        let currentPriceLabel = UILabel()
        currentPriceLabel.font = .preferredFont(forTextStyle: .title2)
        return currentPriceLabel
    }()
    private let fluctuatedRateLabel: UILabel = {
        let fluctuatedRateLabel = UILabel()
        fluctuatedRateLabel.font = .preferredFont(forTextStyle: .title2)
        return fluctuatedRateLabel
    }()
    private let fluctuatedPriceLabel: UILabel = {
        let fluctuatedPriceLabel = UILabel()
        fluctuatedPriceLabel.font = .preferredFont(forTextStyle: .title3)
        return fluctuatedPriceLabel
    }()
    private let transactionAmountLabel: UILabel = {
        let transactionAmountLabel = UILabel()
        transactionAmountLabel.font = .preferredFont(forTextStyle: .title2)
        return transactionAmountLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierarchy()
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
}
