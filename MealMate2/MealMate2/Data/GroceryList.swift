//
//  GroceryList.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import Foundation

// MARK: - Constants

let GroceryListCacheKey = "GroceryListCacheKey"

class GroceryList {

    // MARK: - Properties

    private var groceries = [Grocery]()
    var count: Int {
        get {
            return groceries.count
        }
    }
    var formattedShareText: String {
        var result = ""
        result += formattedShareMealsFor(category: .breakfast)
        result += formattedShareMealsFor(category: .lunch)
        result += formattedShareMealsFor(category: .dinner)
        result += formattedShareMealsFor(category: .general)
        print(result)
        return result
    }

    private func formattedShareMealsFor(category: GroceryCategory) -> String {
        var result = ""
        let categoryGroceries = groceriesForCategory(category)
        var neededGroceries = [Grocery]()
        for curCategoryGrocery in categoryGroceries {
            if curCategoryGrocery.isChecked == true {
                neededGroceries.append(curCategoryGrocery)
            }
        }
        if neededGroceries.count > 0 {
            result += "\(category.displayName)\n"
            for curNeededGrocery in neededGroceries {
                if curNeededGrocery.isChecked {
                    result += "\t- \(curNeededGrocery.name)\n"
                }
            }
        }
        return result
    }

    // MARK: - Init

    static let shared = GroceryList()

    init() {
        loadGroceries()
    }

    // MARK: - Saving / Loading

    func saveGroceries() {
        let groceryListData = try? NSKeyedArchiver.archivedData(withRootObject: groceries, requiringSecureCoding: false)
        UserDefaults.standard.set(groceryListData, forKey: GroceryListCacheKey)
        UserDefaults.standard.synchronize()
    }

    func loadGroceries() {
        if let groceryListData = UserDefaults.standard.data(forKey: GroceryListCacheKey) {
            if let cachedGroceries = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(groceryListData) as? [Grocery] {
                groceries = cachedGroceries.sorted(by: { $0.index < $1.index } )
            }
        }
    }

    // MARK - Adding / Removing / Filtering

    func addGrocery(_ grocery: Grocery) {
        groceries.append(grocery)
        saveGroceries()
    }

    func removeGrocery(_ grocery: Grocery) {
        for (index, curGrocery) in groceries.enumerated() {
            if curGrocery.identifier == grocery.identifier {
                groceries.remove(at: index)
                saveGroceries()
                break
            }
        }
    }

    func grocery(at index: Int) -> Grocery {
        return groceries[index]
    }

    func groceriesForCategory(_ category: GroceryCategory) -> [Grocery] {
        var result = [Grocery]()
        for curGrocery in groceries {
            if curGrocery.category == category {
                result.append(curGrocery)
            }
        }
        return result
    }

    func checkedGroceries() -> [Grocery] {
        var result = [Grocery]()
        for curGrocery in groceries {
            if curGrocery.isChecked == true {
                result.append(curGrocery)
            }
        }
        return result
    }

    func groceryWithId(_ identifier: String) -> Grocery? {
        var result: Grocery?
        for curGrocery in groceries {
            if curGrocery.identifier == identifier {
                result = curGrocery
                break
            }
        }
        return result
    }

}
