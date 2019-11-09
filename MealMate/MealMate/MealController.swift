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

    var meal: Meal?

    // MARK: - Init

    static func createControllerFor(meal: Meal?) -> MealController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MealController = storyboard.instantiateViewController(withIdentifier: MealControllerId) as! MealController
        viewController.meal = meal
        return viewController
    }
    
}
