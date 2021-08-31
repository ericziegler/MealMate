//
//  Grocery.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import Foundation

// MARK: - Constants

let GroceryIdCacheKey = "GroceryIdCacheKey"
let GroceryNameCacheKey = "GroceryNameCacheKey"
let GroceryCategoryCacheKey = "GroceryCategoryCacheKey"
let GroceryCheckedCacheKey = "GroceryCheckedCacheKey"
let GroceryIndexCacheKey = "GroceryIndexCacheKey"

// MARK: - Enums

enum GroceryCategory: Int {
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

class Grocery: NSObject, NSCoding {

    // MARK: - Constants

    var identifier = ""
    var name = ""
    var category = GroceryCategory.breakfast
    var isChecked = false
    var index = 0

    // MARK: - Init

    override init() {
        super.init()
        identifier = UUID().uuidString
    }

    // MARK: - NSCoding

    required init?(coder decoder: NSCoder) {
        if let groceryIdentifier = decoder.decodeObject(forKey: GroceryIdCacheKey) as? String {
            identifier = groceryIdentifier
        }
        if let groceryName = decoder.decodeObject(forKey: GroceryNameCacheKey) as? String {
            name = groceryName
        }
        if let groceryCategory = GroceryCategory(rawValue: decoder.decodeInteger(forKey: GroceryCategoryCacheKey)) {
            category = groceryCategory
        }
        if let groceryIndex = decoder.decodeObject(forKey: GroceryIndexCacheKey) as? NSNumber {
            index = groceryIndex.intValue
        }
        isChecked = decoder.decodeBool(forKey: GroceryCheckedCacheKey)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: GroceryIdCacheKey)
        coder.encode(name, forKey: GroceryNameCacheKey)
        coder.encode(category.rawValue, forKey: GroceryCategoryCacheKey)
        coder.encode(isChecked, forKey: GroceryCheckedCacheKey)
        coder.encode(NSNumber(value: index), forKey: GroceryIndexCacheKey)
    }

}
