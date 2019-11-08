//
//  Ingredient.swift
//  MealMate
//
//  Created by Eric Ziegler on 11/7/19.
//  Copyright © 2019 Eric Ziegler. All rights reserved.
//

import Foundation

// MARK: - Constants

let IngredientNameCacheKey = "IngredientNameCacheKey"
let IngredientQuantityCacheKey = "IngredientQuantityCacheKey"
let IngredientNeededCacheKey = "IngredientNeededCacheKey"
let IngredientMealIdCacheKey = "IngredientMealIdCacheKey"

class Ingredient: NSObject, NSCoding {

    // MARK: - Properties

    var name = ""
    var quantity = 0
    var isNeeded = false
    var mealId = ""

    // MARK: - Init

    override init() {
        super.init()
    }

    // MARK: - NSCoding

    required init?(coder decoder: NSCoder) {
        if let ingredientName = decoder.decodeObject(forKey: IngredientNameCacheKey) as? String {
            name = ingredientName
        }
        quantity = decoder.decodeInteger(forKey: IngredientQuantityCacheKey)
        isNeeded = decoder.decodeBool(forKey: IngredientNeededCacheKey)
        if let ingredientMealId = decoder.decodeObject(forKey: IngredientMealIdCacheKey) as? String {
            mealId = ingredientMealId
        }
    }

    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: IngredientNameCacheKey)
        coder.encode(quantity, forKey: IngredientQuantityCacheKey)
        coder.encode(isNeeded, forKey: IngredientNeededCacheKey)
        coder.encode(mealId, forKey: IngredientMealIdCacheKey)
    }

}
