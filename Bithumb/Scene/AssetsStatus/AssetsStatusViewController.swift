//
//  AssetsStatusViewController.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/28.
//

import UIKit

final class AssetsStatusViewController: UIViewController {
    //MARK: Properties
    @IBOutlet private weak var assetsStatusTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private let repository: Repositoryable = Repository()
    private let assetsStatusTableViewDataSource = AssetsStatusTableViewDataSource()
     
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestRestAssetsStatusAPI()
        activityIndicator.startAnimating()
    }
}

//MARK: - SetUp UI
extension AssetsStatusViewController {
    private func setUpTableView() {
        assetsStatusTableView.dataSource = assetsStatusTableViewDataSource
        assetsStatusTableView.register(AssetStatusTableViewCell.self, forCellReuseIdentifier: AssetStatusTableViewCell.identifier)
        assetsStatusTableView.allowsSelection = false
    }
}

//MARK: - Network
extension AssetsStatusViewController {
    private func requestRestAssetsStatusAPI() {
        let assetsStatusRequest = AssetsStatusRequest.lookUpAll
        repository.execute(request: assetsStatusRequest) { [weak self] result in
            switch result {
            case .success(let assetsStatus):
                self?.assetsStatusTableViewDataSource.configure(by: assetsStatus)
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.assetsStatusTableView.reloadData()
                }
            case .failure(let error):
                UIAlertController.showAlert(about: error, on: self)
            }
        }
    }
}
