//
//  AssetStatusTableViewCell.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/28.
//

import UIKit

final class AssetStatusTableViewCell: UITableViewCell {
    static let identifier = String(describing: AssetStatusTableViewCell.self)
    
    private let assetStatusInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private let depositStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    private let withdrawStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
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
    
    func configure(by assetStatusInformation: AssetStatusDTO) {
        symbolLabel.text = assetStatusInformation.symbol
        depositStatusLabel.text = assetStatusInformation.formattedDepositStatus
        withdrawStatusLabel.text = assetStatusInformation.formattedWithdrawStatus
        
        paint(by: assetStatusInformation)
    }
}

extension AssetStatusTableViewCell {
    private func buildHierachy() {
        contentView.addSubview(assetStatusInformationStackView)
        
        assetStatusInformationStackView.addArrangedSubview(symbolLabel)
        assetStatusInformationStackView.addArrangedSubview(depositStatusLabel)
        assetStatusInformationStackView.addArrangedSubview(withdrawStatusLabel)
    }
    
    private func laysOutConstraints() {
        let margin = 8.0
        
        NSLayoutConstraint.activate([
            assetStatusInformationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            assetStatusInformationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            assetStatusInformationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            assetStatusInformationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            
            depositStatusLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            withdrawStatusLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
        
        assetStatusInformationStackView.isLayoutMarginsRelativeArrangement = true
        assetStatusInformationStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func generateColor(by status: Bool?) -> UIColor {
        guard let status = status else {
            return .systemGray
        }
        
        let greenColor = UIColor(red: 0, green: 0.6, blue: 0.298, alpha: 1)
        if status {
            return greenColor
        } else {
            return .systemRed
        }
    }
    
    private func paint(by assetStatus: AssetStatusDTO) {
        depositStatusLabel.textColor = generateColor(by: assetStatus.data.isDepositAvailable)
        withdrawStatusLabel.textColor = generateColor(by: assetStatus.data.isWithdrawalAvailable)
    }
}
