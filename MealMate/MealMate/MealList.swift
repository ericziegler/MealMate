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

    private var meals = [Meal]()
    var count: Int {
        get {
            return meals.count
        }
    }

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

    func meal(at index: Int) -> Meal {
        return meals[index]
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

    func mealWithId(_ identifier: String) -> Meal? {
        var result: Meal?
        for curMeal in meals {
            if curMeal.identifier == identifier {
                result = curMeal
                break
            }
        }
        return result
    }

}

// **** TESTING ONLE ****
// COMMENT OUT BEFORE PRODUCTION

extension MealList {
//
//    func setupTestData() {
//        var meal = Meal()
//        meal.name = "Spaghetti and meatballs"
//        meal.category = .dinner
//
//        var ingredient = Ingredient()
//        ingredient.name = "Pasta noodles"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Spaghetti sauce"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Meatballs"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        addMeal(meal)
//
//        meal = Meal()
//        meal.name = "Steak"
//        meal.category = .dinner
//
//        ingredient = Ingredient()
//        ingredient.name = "Steak"
//        ingredient.quantity = 1
//        ingredient.isNeeded = true
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Baked potatoes"
//        ingredient.quantity = 2
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Steak seasoning"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        addMeal(meal)
//
//        meal = Meal()
//        meal.name = "French toast"
//        meal.category = .breakfast
//        meal.isNeeded = true
//
//        ingredient = Ingredient()
//        ingredient.name = "Texas toast"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Butter"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Syrup"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        addMeal(meal)
//
//        meal = Meal()
//        meal.name = "BLT sandwich"
//        meal.category = .lunch
//        meal.isNeeded = true
//
//        ingredient = Ingredient()
//        ingredient.name = "Bacon"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Lettuce"
//        ingredient.quantity = 1
//        ingredient.isNeeded = true
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        ingredient = Ingredient()
//        ingredient.name = "Tomato"
//        ingredient.quantity = 1
//        ingredient.isNeeded = false
//        ingredient.mealId = meal.identifier
//        meal.addIngredient(ingredient)
//
//        addMeal(meal)
//
//        meal = Meal()
//        meal.name = "2% Milk"
//        meal.category = .misc
//        meal.isNeeded = true
//
//        addMeal(meal)
//    }
//
//    func clearTestData() {
//        meals.removeAll()
//        saveMeals()
//    }
//
//    func printTestData() {
//        loadMeals()
//        for curMeal in meals {
//            print("Meal Name\t\(curMeal.name)")
//            print("Category\t\(curMeal.category.displayName)")
//            print("Ingredients:")
//            for i in 0..<curMeal.ingredientCount {
//                let curIngredient = curMeal.ingredient(at: i)
//                print("\t\(curIngredient.quantity) x \t\(curIngredient.name) is \(curIngredient.isNeeded)")
//            }
//            print("Is Needed\t\(curMeal.isNeeded)")
//            print("\n")
//        }
//    }
}
