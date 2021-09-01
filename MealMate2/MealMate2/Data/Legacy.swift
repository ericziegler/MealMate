//
//  Legacy.swift
//  MealMate2
//
//  Created by Eric Ziegler on 9/1/21.
//

import Foundation

// This file exists to convert old "Meal" data models to new "Grocery" data models.
// Its purpose it to load from the cache, convert to Grocery objects, and enter them into the new grocery system

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
    var isNeeded = false

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
        isNeeded = decoder.decodeBool(forKey: MealNeededCacheKey)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: MealIdCacheKey)
        coder.encode(name, forKey: MealNameCacheKey)
        coder.encode(category.rawValue, forKey: MealCategoryCacheKey)
        coder.encode(isNeeded, forKey: MealNeededCacheKey)
    }
    
    // MARK: - Conversion
    
    func convertToGrocery() -> Grocery {
        let grocery = Grocery()
        grocery.identifier = identifier
        grocery.name = name
        grocery.category = Category(rawValue: category.rawValue)!
        grocery.isChecked = !isNeeded
        return grocery
    }

}
