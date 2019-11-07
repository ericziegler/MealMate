//
//  MealList.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import Foundation

// MARK: - Constants

let MealListCacheKey = "MealListCacheKey"

class MealList {

    // MARK: - Properties

    var meals = [Meal]()

    // MARK: - Init

    static let shared = MealList()

    init() {
        loadMeals()
    }

    // MARK: - Saving / Loading

    func saveMeals() {
        let mealListData = NSKeyedArchiver.archivedData(withRootObject: meals)
        UserDefaults.standard.set(mealListData, forKey: MealListCacheKey)
        UserDefaults.standard.synchronize()
    }

    func loadMeals() {
        if let mealListData = UserDefaults.standard.data(forKey: MealListCacheKey) {
            if let meals = NSKeyedUnarchiver.unarchiveObject(with: mealListData) as? [Meal] {
                self.meals = meals
            }
        }
    }

    // MARK - Adding / Removing / Filtering

    func addMeal(_ meal: Meal) {
        meals.append(meal)
        saveMeals()
    }

    func removeMealAt(index: Int) {
        meals.remove(at: index)
        saveMeals()
    }

    func mealsForCategory(_ category: MealCategory) -> [Meal] {
        var result = [Meal]()
        for curMeal in meals {
            if curMeal.category == category {
                result.append(curMeal)
            }
        }
        return result
    }

    func neededMeals() -> [Meal] {
        var result = [Meal]()
        for curMeal in meals {
            if curMeal.isNeeded == true {
                result.append(curMeal)
            }
        }
        return result
    }

}
