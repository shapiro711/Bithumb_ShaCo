//
//  AssetsStatusHeaderView.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/30.
//

import UIKit

final class AssetsStatusHeaderView: UIView {
    private let attributeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = "가산자산명"
        return label
    }()
    private let depositStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.text = "📥 입금"
        return label
    }()
    private let withdrawalStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.text = "📤 출금"
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

extension AssetsStatusHeaderView {
    private func buildHierachy() {
        addSubview(attributeStackView)
        
        attributeStackView.addArrangedSubview(coinNameLabel)
        attributeStackView.addArrangedSubview(depositStatusLabel)
        attributeStackView.addArrangedSubview(withdrawalStatusLabel)
    }
    
    private func laysOutConstraints() {
        let margin = 8.0
        
        NSLayoutConstraint.activate([
            attributeStackView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            attributeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            attributeStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            attributeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            
            depositStatusLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            withdrawalStatusLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
        
        attributeStackView.isLayoutMarginsRelativeArrangement = true
        attributeStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
