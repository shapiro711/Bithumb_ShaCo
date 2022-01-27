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
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by transactionInformation: TransactionDTO) {
        
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
}

final class TransactionPriceSpreadsheetCell: Cell {
    static let identifier = String(describing: TransactionPriceSpreadsheetCell.self)
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by transactionInformation: TransactionDTO, priceTrend: PriceTrend) {
        
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
}


final class TransactionQuantityTimeSpreadsheetCell: Cell {
    static let identifier = String(describing: TransactionQuantityTimeSpreadsheetCell.self)
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by transactionInformation: TransactionDTO) {
        
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
}

