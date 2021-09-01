//
//  Category.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import Foundation

// MARK: - Enums

enum Category: Int {
    case breakfast
    case lunch
    case dinner
    case general
    case count

    var displayName: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .general:
            return "General"
        default:
            return ""
        }
    }
    
    var imageName: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .general:
            return "General"
        default:
            return ""
        }
    }
}
