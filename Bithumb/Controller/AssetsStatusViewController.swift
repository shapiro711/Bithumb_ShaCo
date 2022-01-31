//
//  AssetsStatusViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/28.
//

import UIKit

final class AssetsStatusViewController: UIViewController {
    @IBOutlet private weak var assetsStatusTableView: UITableView!
    private let repository: Repositoryable = Repository()
    private let assetsStatusTableViewDataSource = AssetsStatusTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestRestAssetsStatusAPI()
    }
}

extension AssetsStatusViewController {
    private func setUpTableView() {
        assetsStatusTableView.dataSource = assetsStatusTableViewDataSource
        assetsStatusTableView.register(AssetStatusTableViewCell.self, forCellReuseIdentifier: AssetStatusTableViewCell.identifier)
        assetsStatusTableView.allowsSelection = false
    }
}

extension AssetsStatusViewController {
    private func requestRestAssetsStatusAPI() {
        let assetsStatusRequest = AssetsStatusRequest.lookUpAll
        repository.execute(request: assetsStatusRequest) { [weak self] result in
            switch result {
            case .success(let assetsStatus):
                self?.assetsStatusTableViewDataSource.configure(by: assetsStatus)
                DispatchQueue.main.async {
                    self?.assetsStatusTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}
