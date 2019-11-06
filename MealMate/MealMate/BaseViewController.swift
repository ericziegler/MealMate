//
//  BaseViewController.swift
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

