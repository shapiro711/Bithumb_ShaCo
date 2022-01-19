//
//  ViewController.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let repo = Repository()
        repo.execute(request: AssetsStatusRequest.lookUpAll) { result in
            print(result)
        }
    }


}

