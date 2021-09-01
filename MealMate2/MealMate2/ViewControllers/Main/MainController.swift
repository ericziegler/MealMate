//
//  MainController.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/30/21.
//

import UIKit
import AVFoundation
import AudioToolbox

class MainController: BaseViewController, UITableViewDataSource, UITableViewDelegate, InputViewDelegate, GroceryCellDelegate {

    // MARK: - Properties
    
    static let storyboardId = "MainControllerId"
    
    @IBOutlet var groceryTable: UITableView!
    @IBOutlet var addButton: RegularButton!
    
    let groceryList = GroceryList.shared
    private var modalInput: InputView?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTable()
        setupGestureRecognizer()
    }
    
    private func setupNavBar() {
        self.title = "Groceries"
        
        if let shareImage = UIImage(named: "Share")?.maskedWithColor(UIColor.appLight) {
            let shareButton = UIButton(type: .custom)
            shareButton.addTarget(self, action: #selector(shareTapped(_:)), for: .touchUpInside)
            shareButton.setImage(shareImage, for: .normal)
            shareButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            let shareItem = UIBarButtonItem(customView: shareButton)
            self.navigationItem.rightBarButtonItem = shareItem
        }
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
    
    @IBAction func shareTapped(_ sender: AnyObject) {
        let items = [groceryList.generateShareText()]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    // MARK: - Helpers
    
    func groceryAt(indexPath: IndexPath) -> Grocery {
        let category = Category(rawValue: indexPath.section)!
        let grocery = groceryList.groceriesForCategory(category)[indexPath.row]
        return grocery
    }
    
    private func toggleCheckedAt(indexPath: IndexPath) {
        DispatchQueue.main.async {
            let grocery = self.groceryAt(indexPath: indexPath)
            self.groceryTable.beginUpdates()
            grocery.isChecked = !grocery.isChecked
            self.groceryList.saveGroceries()
            self.groceryTable.reloadRows(at: [indexPath], with: .automatic)
            self.groceryTable.endUpdates()
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    private func deleteAt(indexPath: IndexPath) {
        DispatchQueue.main.async {
            let grocery = self.groceryAt(indexPath: indexPath)
            self.groceryList.removeGrocery(grocery)
            self.groceryTable.reloadData()
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category(rawValue: section)!
        return groceryList.groceriesForCategory(category).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroceryCell.reuseId, for: indexPath) as! GroceryCell
        let grocery = groceryAt(indexPath: indexPath)
        cell.layoutFor(grocery: grocery)
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grocery = groceryAt(indexPath: indexPath)
        DispatchQueue.main.async {
            self.modalInput = InputView.createInputFor(parentController: self, grocery: grocery, indexPath: indexPath, delegate: self)
            self.modalInput?.showInput()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let category = Category(rawValue: section)!
        if groceryList.groceriesForCategory(category).count > 0 {
            return 55
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = Category(rawValue: section)!

        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
        bg.backgroundColor = UIColor.appMedium

        let icon = UIImageView(image: UIImage(named: category.displayName)?.maskedWithColor(UIColor.appMediumDark))
        icon.contentMode = .scaleAspectFit
        bg.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        var leadingConstraint = NSLayoutConstraint(item: icon, attribute: .leading, relatedBy: .equal, toItem: bg, attribute: .leading, multiplier: 1, constant: 15)
        var centerConstraint = NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: bg, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22)
        let heightConstraint = NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22)
        bg.addConstraints([leadingConstraint, centerConstraint, widthConstraint, heightConstraint])

        let nameLabel = BoldLabel(frame: .zero)
        nameLabel.text = category.displayName
        nameLabel.textColor = UIColor.appMediumDark
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.appBoldFontOfSize(24)
        bg.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: icon, attribute: .trailing, multiplier: 1, constant: 10)
        centerConstraint = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: icon, attribute: .centerY, multiplier: 1, constant: 0)
        bg.addConstraints([leadingConstraint, centerConstraint])

        return bg
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: title, handler: { [unowned self] (action, view, completionHandler) in
            DispatchQueue.main.async {
                self.toggleCheckedAt(indexPath: indexPath)
                completionHandler(true)
            }
        })
        action.backgroundColor = UIColor.appNavy
        action.image = UIImage(systemName: "checkmark")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: title, handler: { [unowned self] (action, view, completionHandler) in
            DispatchQueue.main.async {
                self.deleteAt(indexPath: indexPath)
                completionHandler(true)
            }
        })
        action.backgroundColor = UIColor.systemRed
        action.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    // MARK: - InputViewDelegate
    
    func groceryAdded(_ grocery: Grocery, forInputView inputView: InputView) {
        groceryList.addGrocery(grocery, toCategory: grocery.category)
        DispatchQueue.main.async {
            self.groceryTable.reloadData()
            inputView.hideInput()
        }
    }
    
    func groceryUpdated(_ grocery: Grocery, indexPath: IndexPath, forInputView inputView: InputView) {
        inputView.hideInput()
        DispatchQueue.main.async {
            // if the section has not changed, just reload the row. if it has, reload the entire table.
            if indexPath.section == grocery.category.rawValue {
                self.groceryTable.reloadRows(at: [indexPath], with: .none)
            } else {
                self.groceryList.updateGroceryCategory(grocery)
                self.groceryTable.reloadData()
            }
            inputView.hideInput()
        }
    }
    
    func inputViewCancelled(_ inputView: InputView) {
        inputView.hideInput()
    }
    
    // MARK: - GroceryCellDelegate
    
    func checkTappedFor(cell: GroceryCell) {
        guard let indexPath = self.groceryTable.indexPath(for: cell) else {
            return
        }
        toggleCheckedAt(indexPath: indexPath)
    }
    
}

