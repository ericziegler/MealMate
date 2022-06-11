//
//  GroceryList.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import Foundation

// MARK: - Constants

let GroceryListCacheKey = "GroceryListCacheKey"
let LegacyMealsCacheKey = "MealListCacheKey"
let LegacyLoadedCacheKey = "LegacyLoadedCacheKey"

// MARK: - Enums

enum GroceryFilter: Int {
    case all
    case pickedUp
    case notPickedUp
}

class GroceryList {

    // MARK: - Properties

    // 2-dimensional array, each item in the array represents a collection of groceries for a specific category
    // e.g. allGroceries[0] = groceries with a category of Category.breakfast
    //      allGroceries[1] = groceries with a category of Category.lunch, etc.
    private var allGroceries = [[Grocery]]()

    // MARK: - Init

    static let shared = GroceryList()

    init() {
        buildCategories()
        loadGroceries()
    }
    
    private func buildCategories() {
        allGroceries.removeAll()
        // instantiate an empty array of Grocery for each Category
        for _ in 0 ..< Category.count.rawValue {
            allGroceries.append([Grocery]())
        }
    }

    // MARK: - Saving

    // groceries are not saved in their category arrays. rather, they are saved as a single array of groceries.
    // they will be rebuilt into their category arrays based on the grocery.category property in loadGroceries
    func saveGroceries() {
        let groceriesToCache = combineCategoryGroceries()
        let groceryListData = try? NSKeyedArchiver.archivedData(withRootObject: groceriesToCache, requiringSecureCoding: false)
        UserDefaults.standard.set(groceryListData, forKey: GroceryListCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    private func combineCategoryGroceries() -> [Grocery] {
        var combinedGroceries = [Grocery]()
        for categoryGroceries in allGroceries {
            for curGrocery in categoryGroceries {
                combinedGroceries.append(curGrocery)
            }
        }
        return combinedGroceries
    }
    
    // MARK: - Loading

    // we have a single array of groceries. we need to separate the groceries out into the appropriate category arrays based
    // on their grocery.category property
    func loadGroceries() {
        if UserDefaults.standard.bool(forKey: LegacyLoadedCacheKey) == true {
            if let groceryListData = UserDefaults.standard.data(forKey: GroceryListCacheKey) {
                if let cachedGroceries = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(groceryListData) as? [Grocery] {
                    placeGroceriesInCategories(ungroupedGroceries: cachedGroceries)
                }
            }
        } else {
            loadLegacyData()
        }
    }
    
    private func placeGroceriesInCategories(ungroupedGroceries: [Grocery]) {
        buildCategories()
        for curGrocery in ungroupedGroceries {
            allGroceries[curGrocery.category.rawValue].append(curGrocery)
        }
        // sort the groceries in each category based on their index
        sortGroceries()
    }
    
    private func loadLegacyData() {
        if let mealListData = UserDefaults.standard.data(forKey: LegacyMealsCacheKey) {
            if let meals = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mealListData) as? [Meal] {
                var convertedGroceries = [Grocery]()
                for curMeal in meals {
                    let grocery = curMeal.convertToGrocery()
                    convertedGroceries.append(grocery)
                }
                placeGroceriesInCategories(ungroupedGroceries: convertedGroceries)
                saveGroceries()
            }
        }
        UserDefaults.standard.set(true, forKey: LegacyLoadedCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Sorting
    
    private func sortGroceries() {
        for (i, categoryGroceries) in allGroceries.enumerated() {
            let sortedGroceries = categoryGroceries.sorted(by: { $0.index < $1.index })
            allGroceries[i] = sortedGroceries
        }
    }
    
    // for each category, loop through the groceries and update their index property based on their position within the category array
    private func updateIndexes() {
        for categoryGroceries in allGroceries {
            for (i, curGrocery) in categoryGroceries.enumerated() {
                curGrocery.index = i
            }
        }
        saveGroceries()
    }

    // MARK - Adding / Removing

    func addGrocery(_ grocery: Grocery, toCategory category: Category) {
        // set the grocery's index to the end of the array before adding it
        allGroceries[category.rawValue].append(grocery)
        updateIndexes()
    }
    
    func removeGrocery(_ grocery: Grocery) {
        let categoryGroceries = allGroceries[grocery.category.rawValue]
        for (i, curGrocery) in categoryGroceries.enumerated() {
            if curGrocery.identifier == grocery.identifier {
                allGroceries[grocery.category.rawValue].remove(at: i)
                updateIndexes()
                break
            }
        }
    }
    
    // MARK: - Accessors
    
    func grocery(at index: Int, inCategory category: Category) -> Grocery? {
        return allGroceries[category.rawValue][index]
    }

    func groceriesForCategory(_ category: Category, filter: GroceryFilter) -> [Grocery] {
        let categoryGroceries = allGroceries[category.rawValue]
        
        switch filter {
        case .pickedUp:
            return categoryGroceries.filter() { $0.isChecked == true }
        case .notPickedUp:
            return categoryGroceries.filter() { $0.isChecked == false }
        default:
            return categoryGroceries
        }
    }
    
    // MARK: - Moving
    
    func moveGrocery(grocery: Grocery, toIndex index: Int, inCategory category: Category) {
        if grocery.category != category {
            // if the grocery has changed categories, remove it from the current category,
            // add it to the new category, and update the grocery.category property
            var oldCategoryGroceries = allGroceries[grocery.category.rawValue]
            oldCategoryGroceries.remove(at: grocery.index)
            allGroceries[grocery.category.rawValue] = oldCategoryGroceries
            
            var newCategoryGroceries = allGroceries[category.rawValue]
            newCategoryGroceries.insert(grocery, at: index)
            allGroceries[category.rawValue] = newCategoryGroceries
            
            grocery.category = category
        } else {
            // grocery moved within the same category. move internally within the array
            var categoryGroceries = allGroceries[category.rawValue]
            categoryGroceries.insert(categoryGroceries.remove(at: grocery.index), at: index)
            allGroceries[category.rawValue] = categoryGroceries
        }
        // update all indexes after the move is complete
        updateIndexes()
    }
    
    // if a grocery's category has changed, it needs to be moved to the appropriate category array
    func updateGroceryCategory(_ grocery: Grocery) {
        // loop through all categories to find where the grocery used to live
        // remove it from this category when it has been found
        for (categoryGroceriesIndex, categoryGroceries) in allGroceries.enumerated() {
            for (curGroceryIndex, curGrocery) in categoryGroceries.enumerated() {
                if curGrocery.identifier == grocery.identifier {
                    allGroceries[categoryGroceriesIndex].remove(at: curGroceryIndex)
                    break
                }
            }
        }
        // add the grocery to its new category array at the end
        allGroceries[grocery.category.rawValue].append(grocery)
        // update indexes after updating the category arrays
        updateIndexes()
    }
    
    // MARK: - Searching
    
    func searchFor(text: String) -> [Grocery] {
        var searchResults = [Grocery]()
        for categoryGroceries in allGroceries {
            for curGrocery in categoryGroceries {
                if curGrocery.name.lowercased().contains(text.lowercased()) {
                    searchResults.append(curGrocery)
                }
            }
        }
        return searchResults.sorted(by: { $0.name < $1.name })
    }
    
    // MARK: - Sharing
    
    func generateShareText(filter: GroceryFilter) -> String {
        var result = ""
        result += formattedShareMealsFor(category: .breakfast, filter: filter)
        result += formattedShareMealsFor(category: .lunch, filter: filter)
        result += formattedShareMealsFor(category: .dinner, filter: filter)
        result += formattedShareMealsFor(category: .general, filter: filter)
        print(result)
        return result
    }

    private func formattedShareMealsFor(category: Category, filter: GroceryFilter) -> String {
        var result = ""
        let categoryGroceries = groceriesForCategory(category, filter: filter)
        if categoryGroceries.count > 0 {
            result += "\(category.displayName)\n"
            for curCheckedGrocery in categoryGroceries {
                result += "\t- \(curCheckedGrocery.name)\n"
            }
        }
        return result
    }
    
}
