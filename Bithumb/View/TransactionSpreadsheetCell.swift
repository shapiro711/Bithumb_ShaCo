//
//  TransactionSpreadsheetCell.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/27.
//

import Foundation
import SpreadsheetView

final class TransactionTimeSpreadsheetCell: Cell {
    static let identifier = String(describing: TransactionTimeSpreadsheetCell.self)
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraint()
        paintBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by transactionInformation: TransactionDTO) {
        informationLabel.text = transactionInformation.formattedDate
    }
    
    private func buildHierachy() {
        contentView.addSubview(informationLabel)
    }
    
    private func laysOutConstraint() {
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func paintBackground() {
        contentView.backgroundColor = .systemBackground
    }
}

final class TransactionPriceSpreadsheetCell: Cell {
    static let identifier = String(describing: TransactionPriceSpreadsheetCell.self)
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraint()
        paintBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by transactionInformation: TransactionDTO, priceTrend: PriceTrend) {
        informationLabel.text = transactionInformation.formattedPrice
        paint(by: priceTrend)
    }
    
    private func buildHierachy() {
        contentView.addSubview(informationLabel)
    }
    
    private func laysOutConstraint() {
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            informationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func paintBackground() {
        contentView.backgroundColor = .systemBackground
    }
    
    private func paint(by priceTrend: PriceTrend) {
        switch priceTrend {
        case .up:
            informationLabel.textColor = .systemRed
        case .equal:
            informationLabel.textColor = .label
        case .down:
            informationLabel.textColor = .systemBlue
        }
    }
}


final class TransactionQuantityTimeSpreadsheetCell: Cell {
    static let identifier = String(describing: TransactionQuantityTimeSpreadsheetCell.self)
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraint()
        paintBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by transactionInformation: TransactionDTO) {
        informationLabel.text = transactionInformation.formattedQuantity
        paint(by: transactionInformation.type)
    }
    
    private func buildHierachy() {
        contentView.addSubview(informationLabel)
    }
    
    private func laysOutConstraint() {
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            informationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func paintBackground() {
        contentView.backgroundColor = .systemBackground
    }
    
    private func paint(by orderType: OrderType?) {
        guard let orderType = orderType else {
            informationLabel.textColor = .label
            return
        }
        
        switch orderType {
        case .ask:
            informationLabel.textColor = .systemBlue
        case .bid:
            informationLabel.textColor = .systemRed
        }
    }
}

