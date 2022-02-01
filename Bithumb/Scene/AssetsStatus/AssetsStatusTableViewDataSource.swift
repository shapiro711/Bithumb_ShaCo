//
//  AssetsStatusTableViewDataSource.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/28.
//

import UIKit

final class AssetsStatusTableViewDataSource: NSObject {
    private var assetsStatus: [AssetStatusDTO] = []
    
    func configure(by assetsStatus: [AssetStatusDTO]) {
        self.assetsStatus = assetsStatus
    }
}

//MARK: - Conform to UITableViewDataSource
extension AssetsStatusTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetStatusTableViewCell.identifier, for: indexPath) as? AssetStatusTableViewCell else {
            return UITableViewCell()
        }
        
        let assetStatus = assetsStatus[indexPath.row]
        cell.configure(by: assetStatus)
        
        return cell 
    }
}
