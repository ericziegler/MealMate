//
//  BaseViewController.swift
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Properties

    var baseNavController: BaseNavigationController? {
        guard let navController = self.navigationController as? BaseNavigationController else {
            return nil
        }
        return navController
    }

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        updateAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance()
    }

    // MARK: - Helpers

    private func updateAppearance() {
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
        self.view.backgroundColor = UIColor.appLight
    }

    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
