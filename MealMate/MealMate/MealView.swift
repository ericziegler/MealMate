//
//  MealView.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/10/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let CardViewTopConstant: CGFloat = 90

// MARK: - Protocols

protocol MealViewDelegate {
    func mealViewDidClose(mealView: MealView)
    func mealDidEncounterError(mealView: MealView, error: String)
}

class MealView: UIView {

    // MARK: - Properties

    @IBOutlet var cardView: UIView!
    @IBOutlet var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var addUpdateButton: RegularButton!
    @IBOutlet var titleLabel: BoldLabel!
    @IBOutlet var nameField: StyledTextField!
    @IBOutlet var categorySegments: UISegmentedControl!
    var meal: Meal?
    var mealId = ""
    var mealName = ""
    var mealCategory = MealCategory.breakfast
    var delegate: MealViewDelegate?

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15
        cardViewTopConstraint.constant = self.frame.size.height
        categorySegments.ensureiOS12Style()
    }

    // MARK: - Animation

    func showCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardViewTopConstraint.constant = CardViewTopConstant
            self.layoutIfNeeded()
        }
    }

    func hideCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.cardViewTopConstraint.constant = self.frame.size.height
            self.layoutIfNeeded()
        }) { (didFinish) in
            UIView.animate(withDuration: 0.1) {
                self.alpha = 0
                self.delegate?.mealViewDidClose(mealView: self)
            }
        }
    }

    // MARK: - Actions

    @IBAction func addUpdateTapped(_ sender: AnyObject) {
        if let text = nameField.text, text.count > 0 {
            mealName = text
            performAddUpdate()
            hideCard()
        } else {
            delegate?.mealDidEncounterError(mealView: self, error: "Meal must have a valid name.")
        }
    }

    @IBAction func cancelTapped(_ sender: AnyObject) {
        hideCard()
    }

    @IBAction func categoryChanged(_ sender: AnyObject) {
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

    // MARK: - Meal Syncing

    func setupMeal() {
        if let meal = self.meal {
            mealId = meal.identifier
            mealName = meal.name
            nameField.text = mealName
            mealCategory = meal.category
            categorySegments.selectedSegmentIndex = mealCategory.rawValue
            titleLabel.text = "Update Meal"
            addUpdateButton.setTitle("Update", for: .normal)
        } else {
            titleLabel.text = "Add Meal"
            addUpdateButton.setTitle("Add", for: .normal)
        }
    }

    private func performAddUpdate() {
        if let meal = self.meal {
            meal.identifier = mealId
            meal.name = mealName
            meal.category = mealCategory
        } else {
            let meal = Meal()
            meal.name = mealName
            meal.category = mealCategory
            meal.isNeeded = true
            MealList.shared.addMeal(meal)
        }
        MealList.shared.saveMeals()
    }

}

extension MealView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        mealName = (textField.text) ?? ""
    }

}
