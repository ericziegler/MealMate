//
//  MealListController.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let MealListControllerId = "MealListControllerId"
let MealHeaderHeight: CGFloat = 60

class MealListController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var headerView: UIView!
    @IBOutlet var mealTable: UITableView!    
    @IBOutlet var noDataView: UIView!
    var mealList = MealList.shared

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        setupNavBar()
    }

    private func setupNavBar() {
        self.title = "Meal Mate"
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()

        if let shareImage = UIImage(named: "Share") {
            let shareButton = UIButton(type: .custom)
            shareButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            shareButton.setImage(shareImage, for: .normal)
            shareButton.frame = CGRect(x: 0, y: 0, width: shareImage.size.width, height: shareImage.size.height)
            let shareItem = UIBarButtonItem(customView: shareButton)
            self.navigationItem.leftBarButtonItems = [shareItem]
        }

        if let addImage = UIImage(named: "Add") {
            let addButton = UIButton(type: .custom)
            addButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            addButton.setImage(addImage, for: .normal)
            addButton.frame = CGRect(x: 0, y: 0, width: addImage.size.width, height: addImage.size.height)
            let addItem = UIBarButtonItem(customView: addButton)
            self.navigationItem.rightBarButtonItems = [addItem]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForMeals()
    }

    // MARK: - Actions

    @IBAction func addTapped(_ sender: AnyObject) {
        let controller = MealController.createControllerFor(meal: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func shareTapped(_ sender: AnyObject) {
        let controller = GroceriesController.createController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    // MARK: - Layout

    private func checkForMeals() {
        mealList.loadMeals()
        if mealList.count > 0 {
            noDataView.isHidden = true
            mealTable.reloadData()
        } else {
            self.view.bringSubviewToFront(noDataView)
            noDataView.isHidden = false
        }
    }

}

extension MealListController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = MealCategory(rawValue: section)!
        return mealList.mealsForCategory(category).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealCellId, for: indexPath) as! MealCell
        let category = MealCategory(rawValue: indexPath.section)!
        let meal = mealList.mealsForCategory(category)[indexPath.row]
        cell.delegate = self
        cell.layoutFor(meal: meal)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MealCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = MealCategory(rawValue: indexPath.section)!
        let meal = mealList.mealsForCategory(category)[indexPath.row]
        let controller = MealController.createControllerFor(meal: meal)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = MealCategory(rawValue: indexPath.section)!
            let categoryMeals = mealList.mealsForCategory(category)
            let meal = categoryMeals[indexPath.row]
            for i in 0..<mealList.count {
                if mealList.meal(at: i).identifier == meal.identifier {
                    mealList.removeMealAt(index: i)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    break
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let category = MealCategory(rawValue: section)!
        if mealList.mealsForCategory(category).count > 0 {
            return MealHeaderHeight
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = MealCategory(rawValue: section)!

        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
        bg.backgroundColor = UIColor.appLightGray

        let icon = UIImageView(image: UIImage(named: category.displayName)?.maskedImageWithColor(UIColor.appDark))
        icon.contentMode = .scaleAspectFit
        bg.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        var leadingConstraint = NSLayoutConstraint(item: icon, attribute: .leading, relatedBy: .equal, toItem: bg, attribute: .leading, multiplier: 1, constant: 15)
        var centerConstraint = NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: bg, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let heightConstraint = NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        bg.addConstraints([leadingConstraint, centerConstraint, widthConstraint, heightConstraint])

        let nameLabel = BoldLabel(frame: .zero)
        nameLabel.text = category.displayName
        nameLabel.textColor = UIColor.appDark
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.applicationBoldFontOfSize(26)
        bg.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: icon, attribute: .trailing, multiplier: 1, constant: 10)
        centerConstraint = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: icon, attribute: .centerY, multiplier: 1, constant: 0)
        bg.addConstraints([leadingConstraint, centerConstraint])

        return bg
    }

}

extension MealListController: MealCellDelegate {

    func checkWasToggled(needed: Bool, mealIdentifier: String) {
        for i in 0..<mealList.count {
            let curMeal = mealList.meal(at: i)
            if curMeal.identifier == mealIdentifier {
                curMeal.isNeeded = needed
                mealList.saveMeals()
                break
            }
        }
    }

}
