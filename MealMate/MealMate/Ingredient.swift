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

class Ingredient: NSObject, NSCoding {

    // MARK: - Properties

    var name = ""
    var quantity = 0
    var isNeeded = false

    // MARK: - NSCoding

    required init?(coder decoder: NSCoder) {
        if let ingredientName = decoder.decodeObject(forKey: IngredientNameCacheKey) as? String {
            name = ingredientName
        }
        quantity = decoder.decodeInteger(forKey: IngredientQuantityCacheKey)
        isNeeded = decoder.decodeBool(forKey: IngredientNeededCacheKey)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: IngredientNameCacheKey)
        coder.encode(quantity, forKey: IngredientQuantityCacheKey)
        coder.encode(isNeeded, forKey: IngredientNeededCacheKey)
    }

}
