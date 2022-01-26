//
//  OrderBookAskTableViewCell.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/26.
//

import UIKit

final class OrderBookAskTableViewCell: UITableViewCell {
    static let identifier = String(describing: OrderBookAskTableViewCell.self)
    
    private let orderInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    private let priceStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()
    private let fluctuatedRateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierachy()
        laysOutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(by askInformation: OrderBookDepthDTO.OrderBookData) {
        priceLabel.text = askInformation.price?.description
        quantityLabel.text = askInformation.quantity?.description
        fluctuatedRateLabel.text = "15.0%"
    }
}

extension OrderBookAskTableViewCell {
    private func buildHierachy() {
        contentView.addSubview(orderInformationStackView)
        
        orderInformationStackView.addArrangedSubview(quantityLabel)
        orderInformationStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(fluctuatedRateLabel)
    }
    
    private func laysOutConstraints() {
        NSLayoutConstraint.activate([
            orderInformationStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            orderInformationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            orderInformationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            quantityLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
            
            priceStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
    }
}
