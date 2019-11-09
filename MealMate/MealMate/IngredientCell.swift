//
//  IngredientCell.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/9/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let IngredientCellId = "IngredientCellId"
let IngredientCellHeight: CGFloat = 55

class IngredientCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var nameLabel: BoldLabel!
    @IBOutlet var checkImageView: UIImageView!

    // MARK: - Layout

    func layoutFor(ingredient: Ingredient) {
        nameLabel.text = ingredient.name
        checkImageView.image = ingredient.isNeeded ? UIImage(named: "CheckSelect") : UIImage(named: "Check")
    }

}
