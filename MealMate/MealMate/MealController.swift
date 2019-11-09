//
//  MealController.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/8/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let MealControllerId = "MealControllerId"

class MealController: BaseViewController {

    // MARK: - Properties

    @IBOutlet var nameField: StyledTextField!
    @IBOutlet var categorySegments: UISegmentedControl!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var addUpdateButton: BoldButton!
    var meal: Meal?
    var mealId = ""
    var mealName = ""
    var mealCategory = MealCategory.breakfast
    var ingredients = [Ingredient]()

    // MARK: - Init

    static func createControllerFor(meal: Meal?) -> MealController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MealController = storyboard.instantiateViewController(withIdentifier: MealControllerId) as! MealController
        viewController.meal = meal
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        categorySegments.ensureiOS12Style()
        setupMeal()
        if meal != nil {
            addUpdateButton.setTitle("Update", for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction func mealCategoryChanged(_ sender: AnyObject) {
        switch categorySegments.selectedSegmentIndex {
        case 0:
            mealCategory = .breakfast
        case 1:
            mealCategory = .lunch
        case 2:
            mealCategory = .dinner
        default:
            mealCategory = .general
        }
    }

    @IBAction func addIngredientTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add Ingredient", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "e.g. 2 lb. Pasta noodles"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                let ingredient = Ingredient()
                ingredient.mealId = self.mealId
                ingredient.name = alertTextField.text!
                ingredient.isNeeded = true
                self.ingredients.append(ingredient)
                self.ingredientTable.reloadData()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func addUpdateTapped(_ sender: AnyObject) {
        if let text = nameField.text, text.count > 0 {
            mealName = text
            performAddUpdate()
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: "A meal must have a name before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func cancelTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Cancel Changes", message: "Are you sure you would like to cancel?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Meal Syncing

    private func setupMeal() {
        if let meal = self.meal {
            mealId = meal.identifier
            mealName = meal.name
            nameField.text = mealName
            mealCategory = meal.category
            categorySegments.selectedSegmentIndex = mealCategory.rawValue
            ingredients.removeAll()
            for i in 0..<meal.ingredientCount {
                let curIngredient = meal.ingredient(at: i)
                ingredients.append(curIngredient)
            }
        }
    }

    private func performAddUpdate() {
        if let meal = self.meal {
            meal.identifier = mealId
            meal.name = mealName
            meal.category = mealCategory
            meal.removeAllIngredients()
            for i in 0..<ingredients.count {
                let curIngredient = ingredients[i]
                meal.addIngredient(curIngredient)
            }
        } else {
            let meal = Meal()
            meal.name = mealName
            meal.category = mealCategory
            for i in 0..<ingredients.count {
                let curIngredient = ingredients[i]
                meal.addIngredient(curIngredient)
            }
            MealList.shared.addMeal(meal)
        }
        MealList.shared.saveMeals()
    }
    
}

extension MealController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        mealName = (textField.text) ?? ""
    }

}

extension MealController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IngredientCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = ingredients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCellId, for: indexPath) as! IngredientCell
        cell.layoutFor(ingredient: ingredient)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        ingredient.isNeeded = !ingredient.isNeeded
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
