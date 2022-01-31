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
        tickerInformationStackView.spacing = 10
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
        currentPriceLabel.numberOfLines = 0
        return currentPriceLabel
    }()
    private let fluctuatedRateLabel: UILabel = {
        let fluctuatedRateLabel = UILabel()
        fluctuatedRateLabel.font = .preferredFont(forTextStyle: .body)
        fluctuatedRateLabel.textAlignment = .right
        fluctuatedRateLabel.numberOfLines = 0
        return fluctuatedRateLabel
    }()
    private let fluctuatedPriceLabel: UILabel = {
        let fluctuatedPriceLabel = UILabel()
        fluctuatedPriceLabel.font = .preferredFont(forTextStyle: .caption1)
        fluctuatedPriceLabel.textAlignment = .right
        return fluctuatedPriceLabel
    }()
    private let transactionAmountLabel: UILabel = {
        let transactionAmountLabel = UILabel()
        transactionAmountLabel.font = .preferredFont(forTextStyle: .body)
        transactionAmountLabel.textAlignment = .right
        transactionAmountLabel.numberOfLines = 0
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
    
    func configure(by tickerInformation: TickerDTO) {
        nameLabel.text = tickerInformation.koreanName
        symbolLabel.text = tickerInformation.formattedSymbol
        currentPriceLabel.text = tickerInformation.formattedCurrentPrice
        fluctuatedRateLabel.text = tickerInformation.formattedRateOfChange
        fluctuatedPriceLabel.text = tickerInformation.formattedAmountOfChange
        transactionAmountLabel.text = tickerInformation.formattedTransactionAmount
        
        choiceColor(by: tickerInformation.data.rateOfChange)
    }
    
    func sparkle(by trend: PriceTrend) {
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        let animationGroup = CAAnimationGroup()
        
        animationGroup.animations = [borderColorAnimation, borderWidthAnimation]
        animationGroup.duration = 0.4
        
        switch trend {
        case .up:
            borderColorAnimation.fromValue = UIColor.systemRed.cgColor
            borderColorAnimation.toValue = UIColor.systemRed.cgColor
            
            borderWidthAnimation.fromValue = 0.8
            borderWidthAnimation.toValue = 0.8
            
            currentPriceLabel.layer.add(animationGroup, forKey: "sparkle")
        case .equal:
            break
        case .down:
            borderColorAnimation.fromValue = UIColor.systemBlue.cgColor
            borderColorAnimation.toValue = UIColor.systemBlue.cgColor
            
            borderWidthAnimation.fromValue = 0.8
            borderWidthAnimation.toValue = 0.8
            
            currentPriceLabel.layer.add(animationGroup, forKey: "sparkle")
        }
    }
}

extension TickerTableViewCell {
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
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
            
            identityStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.24),
            currentPriceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            fluctuationStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.17)
        ])
    }
    
    private func choiceColor(by fluctuation: Double?) {
        currentPriceLabel.textColor = .label
        fluctuatedRateLabel.textColor = .label
        fluctuatedPriceLabel.textColor = .label
        
        guard let fluctuation = fluctuation else {
            return
        }
        
        if fluctuation > 0 {
            currentPriceLabel.textColor = .systemRed
            fluctuatedRateLabel.textColor = .systemRed
            fluctuatedPriceLabel.textColor = .systemRed
        } else if fluctuation < 0 {
            currentPriceLabel.textColor = .systemBlue
            fluctuatedRateLabel.textColor = .systemBlue
            fluctuatedPriceLabel.textColor = .systemBlue
        }
    }
}
