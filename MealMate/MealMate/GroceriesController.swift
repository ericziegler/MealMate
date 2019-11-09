//
//  ShareController.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/9/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let GroceriesControllerId = "GroceriesControllerId"

class GroceriesController: BaseViewController {

    // MARK: - Properrties

    @IBOutlet var listTable: UITableView!
    private var mealList = MealList.shared

    // MARK: - Init

    static func createController() -> GroceriesController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: GroceriesController = storyboard.instantiateViewController(withIdentifier: GroceriesControllerId) as! GroceriesController
        return viewController
    }
    
    // MARK: - Actions

    @IBAction func closeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func shareTapped(_ sender: AnyObject) {
        let image = screenshotTable(tableView: listTable)
        let imageToShare = [image]

        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }

}

extension GroceriesController: UITableViewDataSource, UITableViewDelegate {

    // TODO: In the future, handle displaying ingredients.
    // This is the commented out code in the datasource/delegates.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return mealList.neededMeals().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealList.neededMeals().count
//        let meal = mealList.neededMeals()[section]
//        let ingredients = meal.neededIngredients()
//        return ingredients.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroceryCell = tableView.dequeueReusableCell(withIdentifier: GroceryCellId, for: indexPath) as! GroceryCell
        let meal = mealList.neededMeals()[indexPath.row]
        cell.layoutFor(meal: meal, ingredient: nil)
        return cell
//        let cell: GroceryCell = tableView.dequeueReusableCell(withIdentifier: GroceryCellId, for: indexPath) as! GroceryCell
//        let meal = mealList.neededMeals()[indexPath.section]
//        if indexPath.row == 0 {
//            cell.layoutFor(meal: meal, ingredient: nil)
//        } else {
//            let ingredient = meal.neededIngredients()[indexPath.row - 1]
//            cell.layoutFor(meal: nil, ingredient: ingredient)
//        }
//        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GroceryCellHeight
    }

}
