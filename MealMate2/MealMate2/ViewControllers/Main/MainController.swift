//
//  MainController.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/30/21.
//

import UIKit

class MainController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    static let storyboardId = "MainControllerId"
    
    @IBOutlet var groceryTable: UITableView!
    @IBOutlet var addButton: RegularButton!
    
    private let groceryList = GroceryList.shared
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTable()
    }
    
    private func setupNavBar() {
        self.title = "Groceries"
    }
    
    private func setupTable() {
        groceryTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: AnyObject) {
        print("ADD")
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = GroceryCategory(rawValue: section)!
        return groceryList.groceriesForCategory(category).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroceryCell.reuseId, for: indexPath) as! GroceryCell
        let category = GroceryCategory(rawValue: indexPath.section)!
        let grocery = groceryList.groceriesForCategory(category)[indexPath.row]
        cell.layoutFor(grocery: grocery)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
}

