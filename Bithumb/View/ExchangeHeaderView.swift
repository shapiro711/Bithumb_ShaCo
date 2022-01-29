//
//  ExchangeHeaderView.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/30.
//

import UIKit

final class ExchangeHeaderView: UIView {
    private let attributeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .right
        return label
    }()
    private let fluctuationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .right
        return label
    }()
    private let accumulatedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildHierachy()
        laysoutConstraints()
        configure()
    }
    
    private func configure() {
        nameLabel.text = "가상자산명"
        priceLabel.text = "현재가"
        fluctuationLabel.text = "변동률"
        accumulatedAmountLabel.text = "거래금액"
    }
}

extension ExchangeHeaderView {
    private func buildHierachy() {
        addSubview(attributeStackView)
        
        attributeStackView.addArrangedSubview(nameLabel)
        attributeStackView.addArrangedSubview(priceLabel)
        attributeStackView.addArrangedSubview(fluctuationLabel)
        attributeStackView.addArrangedSubview(accumulatedAmountLabel)
    }
    
    private func laysoutConstraints() {
        let margin = 8.0
        
        NSLayoutConstraint.activate([
            attributeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            attributeStackView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            attributeStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            attributeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.24),
            priceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            fluctuationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.17)
        ])
    }
}
