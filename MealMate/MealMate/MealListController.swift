//
//  MealListController.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let MealControllerId = "MealControllerId"
let MealHeaderHeight: CGFloat = 70

class MealListController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var headerView: UIView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var mealTable: UITableView!    
    @IBOutlet var noDataView: UIView!
    var mealList = MealList.shared

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForMeals()
    }


    // MARK: - Actions

    @IBAction func addTapped(_ sender: AnyObject) {

    }

    @IBAction func shareTapped(_ sender: AnyObject) {

    }

    // MARK: - Layout

    private func checkForMeals() {
        mealList.loadMeals()
        if mealList.count > 0 {
            noDataView.isHidden = true
            mealTable.reloadData()
            shareButton.isEnabled = true
        } else {
            self.view.bringSubviewToFront(noDataView)
            noDataView.isHidden = false
            shareButton.isEnabled = false
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
        bg.backgroundColor = UIColor.appGray

        let icon = UIImageView(image: UIImage(named: category.displayName)?.maskedImageWithColor(UIColor.appDark))
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
