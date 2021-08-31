//
//  MainController.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/30/21.
//

import UIKit

class MainController: BaseViewController, UITableViewDataSource, UITableViewDelegate, InputViewDelegate {

    // MARK: - Properties
    
    static let storyboardId = "MainControllerId"
    
    @IBOutlet var groceryTable: UITableView!
    @IBOutlet var addButton: RegularButton!
    
    private let groceryList = GroceryList.shared
    private var modalInput: InputView?
    
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
        DispatchQueue.main.async {
            self.modalInput = InputView.createInputFor(parentController: self, grocery: nil, indexPath: nil, delegate: self)
            self.modalInput?.showInput()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = GroceryCategory(rawValue: indexPath.section)!
        let grocery = groceryList.groceriesForCategory(category)[indexPath.row]
        DispatchQueue.main.async {
            self.modalInput = InputView.createInputFor(parentController: self, grocery: grocery, indexPath: indexPath, delegate: self)
            self.modalInput?.showInput()
        }
    }
    
    // MARK: - InputViewDelegate
    
    func groceryAdded(_ grocery: Grocery, forInputView inputView: InputView) {
        groceryList.addGrocery(grocery)
        DispatchQueue.main.async {
            self.groceryTable.reloadData()
            inputView.hideInput()
        }
    }
    
    func groceryUpdated(_ grocery: Grocery, indexPath: IndexPath, forInputView inputView: InputView) {
        inputView.hideInput()
        DispatchQueue.main.async {
            self.groceryTable.reloadRows(at: [indexPath], with: .none)
            inputView.hideInput()
        }
    }
    
    func inputViewCancelled(_ inputView: InputView) {
        inputView.hideInput()
    }
    
}

