//
//  MealListController.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

class MealListController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var headerView: UIView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var mealTable: UITableView!
    // TODO: EZ - Add no data view
    //@IBOutlet var noDataView: UIView!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func addTapped(_ sender: AnyObject) {

    }

    @IBAction func shareTapped(_ sender: AnyObject) {

    }

}

extension MealListController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

}
