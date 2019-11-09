//
//  MealCell.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/8/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import UIKit

// MARK: - Constants

let MealCellId = "MealCellId"
let MealCellHeight: CGFloat = 70

// MARK: - Protocols

protocol MealCellDelegate {
    func checkWasToggled(needed: Bool, mealIdentifier: String)
}

class MealCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var bgView: UIView!
    @IBOutlet var nameLabel: BoldLabel!
    @IBOutlet var checkImageView: UIImageView!
    var mealIsNeeded = false
    var mealIdentifier = ""
    var delegate: MealCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12
        bgView.layer.borderColor = UIColor.appDarkGray.cgColor
        bgView.layer.borderWidth = 1
    }

    // MARK: - Actions

    @IBAction func checkTapped(_ sender: AnyObject) {
        mealIsNeeded = !mealIsNeeded
        delegate?.checkWasToggled(needed: mealIsNeeded, mealIdentifier: mealIdentifier)
        updateNeededButton()
    }

    // MARK: - Layout

    func layoutFor(meal: Meal) {
        mealIdentifier = meal.identifier
        nameLabel.text = meal.name
        mealIsNeeded = meal.isNeeded
        updateNeededButton()
    }

    private func updateNeededButton() {
        if mealIsNeeded == true {
            checkImageView.image = UIImage(named: "CheckSelect")
            nameLabel.textColor = UIColor.appMain
        } else {
            checkImageView.image = UIImage(named: "Check")
            nameLabel.textColor = UIColor.appDarkGray
        }
    }

}
