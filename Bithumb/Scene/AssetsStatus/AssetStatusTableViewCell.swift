//
//  AssetStatusTableViewCell.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/28.
//

import UIKit

final class AssetStatusTableViewCell: UITableViewCell {
    //MARK: Properties
    static let identifier = String(describing: AssetStatusTableViewCell.self)
    
    private let assetStatusInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let koreanNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
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
    
    //MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierachy()
        laysOutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(by assetStatusInformation: AssetStatusDTO) {
        koreanNameLabel.text = assetStatusInformation.koreanName
        symbolLabel.text = assetStatusInformation.symbol
        depositStatusLabel.text = assetStatusInformation.formattedDepositStatus
        withdrawStatusLabel.text = assetStatusInformation.formattedWithdrawStatus
        
        paint(by: assetStatusInformation)
    }
}

//MARK: - SetUp UI
extension AssetStatusTableViewCell {
    private func buildHierachy() {
        contentView.addSubview(assetStatusInformationStackView)
        
        assetStatusInformationStackView.addArrangedSubview(nameStackView)
        assetStatusInformationStackView.addArrangedSubview(depositStatusLabel)
        assetStatusInformationStackView.addArrangedSubview(withdrawStatusLabel)
        
        nameStackView.addArrangedSubview(koreanNameLabel)
        nameStackView.addArrangedSubview(symbolLabel)
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
        assetStatusInformationStackView.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
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
