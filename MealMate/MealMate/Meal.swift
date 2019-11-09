//
//  Meal.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

// MARK: - Constants

let MealIdCacheKey = "MealIdCacheKey"
let MealNameCacheKey = "MealNameCacheKey"
let MealCategoryCacheKey = "MealCategoryCacheKey"
let MealIngredientsCacheKey = "MealIngredientsCacheKey"
let MealNeededCacheKey = "MealNeededCacheKey"

// MARK: - Enums

enum MealCategory: Int {
    case breakfast
    case lunch
    case dinner
    case general

    var displayName: String {
        get {
            switch self {
            case .breakfast:
                return "Breakfast"
            case .lunch:
                return "Lunch"
            case .dinner:
                return "Dinner"
            case .general:
                return "General"
            }
        }
    }
}

import Foundation

class Meal: NSObject, NSCoding {

    // MARK: - Constants

    var identifier = ""
    var name = ""
    var category = MealCategory.breakfast
    private var ingredients = [Ingredient]()
    var isNeeded = false
    var ingredientCount: Int {
        get {
            return ingredients.count
        }
    }

    // MARK: - Init

    override init() {
        super.init()
        identifier = UUID().uuidString
    }

    // MARK: - NSCoding

    required init?(coder decoder: NSCoder) {
        if let mealIdentifier = decoder.decodeObject(forKey: MealIdCacheKey) as? String {
            identifier = mealIdentifier
        }
        if let mealName = decoder.decodeObject(forKey: MealNameCacheKey) as? String {
            name = mealName
        }
        if let mealCategory = MealCategory(rawValue: decoder.decodeInteger(forKey: MealCategoryCacheKey)) {
            category = mealCategory
        }
        if let ingredientsData = decoder.decodeObject(forKey: MealIngredientsCacheKey) as? Data, let mealIngredients = NSKeyedUnarchiver.unarchiveObject(with: ingredientsData) as? [Ingredient] {
            ingredients = mealIngredients
        }
        isNeeded = decoder.decodeBool(forKey: MealNeededCacheKey)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: MealIdCacheKey)
        coder.encode(name, forKey: MealNameCacheKey)
        coder.encode(category.rawValue, forKey: MealCategoryCacheKey)
        let ingredientsData = NSKeyedArchiver.archivedData(withRootObject: ingredients)
        coder.encode(ingredientsData, forKey: MealIngredientsCacheKey)
        coder.encode(isNeeded, forKey: MealNeededCacheKey)
    }

    // MARK: - Adding / Removing

    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
        MealList.shared.saveMeals()
    }

    func removeIngredientAt(index: Int) {
        ingredients.remove(at: index)
        MealList.shared.saveMeals()
    }

    func removeAllIngredients() {
        ingredients.removeAll()
    }

    func ingredient(at index: Int) ->Ingredient {
        return ingredients[index]
    }

    // MARK: - Filtering

    func neededIngredients() -> [Ingredient] {
        var result = [Ingredient]()
        for curIngredient in ingredients {
            if curIngredient.isNeeded == true {
                result.append(curIngredient)
            }
        }
        return result
    }

}
