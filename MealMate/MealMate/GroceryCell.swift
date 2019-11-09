//
//  GroceryCell.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/9/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let GroceryCellId = "GroceryCellId"
let GroceryCellHeight: CGFloat = 35

class GroceryCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var mealLabel: BoldLabel!
    @IBOutlet var ingredientLabel: RegularLabel!

    // MARK: - Layout

    func layoutFor(meal: Meal?, ingredient: Ingredient?) {
        mealLabel.isHidden = true
        ingredientLabel.isHidden = true
        if let meal = meal {
            mealLabel.isHidden = false
            mealLabel.text = meal.name
        }
        else if let ingredient = ingredient {            
            ingredientLabel.isHidden = false
            ingredientLabel.text = ingredient.name
        }
    }

}
