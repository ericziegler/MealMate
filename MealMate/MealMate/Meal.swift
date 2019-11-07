//
//  Meal.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

// MARK: - Constants

let MealNameCacheKey = "MealNameCacheKey"
let MealCategoryCacheKey = "MealCategoryCacheKey"
let MealIngredientsCacheKey = "MealIngredientsCacheKey"

// MARK: - Enums

enum MealCategory: Int {
    case breakfast
    case lunch
    case dinner
    case misc

    var displayName: String {
        get {
            switch self {
            case .breakfast:
                return "Breakfast"
            case .lunch:
                return "Lunch"
            case .dinner:
                return "Dinner"
            case .misc:
                return "Misc."
            }
        }
    }
}

import Foundation

class Meal: NSObject, NSCoding {

    // MARK: - Constants

    var name = ""
    var category = MealCategory.misc
    var ingredients = [Ingredient]()
    var isNeeded: Bool {
        get {
            var result = false
            for curIngredient in ingredients {
                if curIngredient.isNeeded == true {
                    result = true
                    break
                }
            }
            return result
        }
    }

    // MARK: - NSCoding

    required init?(coder decoder: NSCoder) {
        if let mealName = decoder.decodeObject(forKey: MealNameCacheKey) as? String {
            name = mealName
        }
        if let mealCategory = MealCategory(rawValue: decoder.decodeInteger(forKey: MealCategoryCacheKey)) {
            category = mealCategory
        }
        if let ingredientsData = decoder.decodeObject(forKey: MealIngredientsCacheKey) as? Data, let mealIngredients = NSKeyedUnarchiver.unarchiveObject(with: ingredientsData) as? [Ingredient] {
            ingredients = mealIngredients
        }
    }

    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: MealNameCacheKey)
        coder.encode(category.rawValue, forKey: MealCategoryCacheKey)
        let ingredientsData = NSKeyedArchiver.archivedData(withRootObject: ingredients)
        coder.encode(ingredientsData, forKey: MealIngredientsCacheKey)
    }

    // MARK: - Need Handling

    func toggleNeeded(needed: Bool) {
        for curIngredient in ingredients {
            curIngredient.isNeeded = needed
        }
        MealList.shared.saveMeals()
    }

}
