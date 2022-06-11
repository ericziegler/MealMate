//
//  Preferences.swift
//  MealMate
//
//  Created by Eric Ziegler on 6/11/22.
//  Copyright © 2022 Eric Ziegler. All rights reserved.
//

import Foundation

class Preferences {
    
    // MARK: - Enums
    
    private enum PreferenceKey: String {
        case lastFilter = "preference.lastFilter"
        case lastCategory = "preference.lastCategory"
    }
 
    // MARK: - Properties
    
    var lastFilter: GroceryFilter = .all
    var lastCategory: Category = .breakfast
    
    // MARK: - Init
    
    static let shared = Preferences()
    
    init() {
        loadPreferences()
    }
    
    // MARK: - Load / Save
    
    private func loadPreferences() {
        let defaults = UserDefaults.standard
        if let lastFilterNumber = defaults.object(forKey: PreferenceKey.lastFilter.rawValue) as? NSNumber, let cachedLastFilter = GroceryFilter(rawValue: lastFilterNumber.intValue) {
            lastFilter = cachedLastFilter
        }
        if let lastCategoryNumber = defaults.object(forKey: PreferenceKey.lastCategory.rawValue) as? NSNumber, let cachedLastCategory = Category(rawValue: lastCategoryNumber.intValue) {
            lastCategory = cachedLastCategory
        }
    }
    
    func savePreferences() {
        let defaults = UserDefaults.standard
        defaults.set(NSNumber(value: lastFilter.rawValue), forKey: PreferenceKey.lastFilter.rawValue)
        defaults.set(NSNumber(value: lastCategory.rawValue), forKey: PreferenceKey.lastCategory.rawValue)
        defaults.synchronize()
    }
    
}
