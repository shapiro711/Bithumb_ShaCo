//
//  TransactionAttributeSpreadSheetCell.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/30.
//

import UIKit
import SpreadsheetView

final class TransactionAttributeSpreadSheetCell: Cell {
    static let identifier = String(describing: TransactionAttributeSpreadSheetCell.self)
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierachy()
        laysOutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(by attributeType: String) {
        attributeLabel.text = attributeType
    }
}

extension TransactionAttributeSpreadSheetCell {
    private func buildHierachy() {
        contentView.addSubview(attributeLabel)
    }
    
    private func laysOutConstraints() {
        NSLayoutConstraint.activate([
            attributeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            attributeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            attributeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
