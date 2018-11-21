//
//  User.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-11-11.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation

class User : Codable {
    
    var name: String
    var email: String
    var likedRecipes: [Meal]?
    var mealPlanDict: [String:[Meal]]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case likedRecipes = "likedRecipes"
        case mealPlanDict = "mealPlan"
    }
    
}

extension User {
    
    public func AddTopMealPlan(mealToAdd: Meal, typeOfMeal: String, _ callback: @escaping (_ success: Bool) -> Void) {
        NetworkManager.shared.AddToMealPlan(mealToAdd.mealId, typeOfMeal, false, callback: callback)
    }
    
    public func RemoveFromMealPlan(mealToAdd: Meal, _ callback: @escaping (_ success: Bool) -> Void) {
        NetworkManager.shared.AddToMealPlan(mealToAdd.mealId, "", true, callback: callback)
    }
    
    public func GetMealPlanBreakfast() -> [Meal] {
        return GetMealsFromDict(key: "breakfast")
    }
    
    public func GetMealPlanLunch() -> [Meal] {
        return GetMealsFromDict(key: "lunch")
    }
    
    public func GetMealPlanDinner() -> [Meal] {
        return GetMealsFromDict(key: "dinner")
    }
    
    private func GetMealsFromDict(key: String) -> [Meal] {
        guard let dict = mealPlanDict, let meals = dict[key] else {
            return []
        }
        return meals
    }
    
}
