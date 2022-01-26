//
//  OrderBookBidTableViewCell.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/26.
//

import UIKit

final class OrderBookBidTableViewCell: UITableViewCell {
    static let identifier = String(describing: OrderBookBidTableViewCell.self)
    
    private let orderInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let priceStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    private let quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let emptyView = UIView()
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .left
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .right
        return label
    }()
    private let fluctuatedRateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierachy()
        laysOutConstraints()
        paint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(by bidInformation: OrderBookDepthDTO.OrderBookData) {
        priceLabel.text = bidInformation.price?.description
        quantityLabel.text = bidInformation.quantity?.description
        fluctuatedRateLabel.text = "15.0%"
    }
}

extension OrderBookBidTableViewCell {
    private func buildHierachy() {
        contentView.addSubview(orderInformationStackView)
        
        orderInformationStackView.addArrangedSubview(emptyView)
        orderInformationStackView.addArrangedSubview(priceStackView)
        orderInformationStackView.addArrangedSubview(quantityStackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(fluctuatedRateLabel)
        
        quantityStackView.addArrangedSubview(quantityLabel)
    }
    
    private func laysOutConstraints() {
        let margin = 5.0
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        NSLayoutConstraint.activate([
            orderInformationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            orderInformationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            orderInformationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            orderInformationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            emptyView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            quantityStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
        
        priceStackView.isLayoutMarginsRelativeArrangement = true
        priceStackView.layoutMargins = insets
        
        quantityStackView.isLayoutMarginsRelativeArrangement = true
        quantityStackView.layoutMargins = insets
    }
    
    private func paint() {
        let redColor = UIColor(red: 1, green: 0.6, blue: 0.6, alpha: 0.5)
        
        priceStackView.backgroundColor = redColor
        quantityStackView.backgroundColor = redColor
    }
}
