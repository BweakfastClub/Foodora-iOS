//
//  Meal.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation

struct Meal : Codable {

    var id: Int
    var title: String
    var nutritionInformation: Dictionary<String, NutritionInfo>
    var ingredients: [Ingredient]
    var servings: Int
    var prepMinutes: Int
    var cookMinutes: Int
    var readyMinutes: Int
    var imageUrl: String

    init(_ title: String, _ imageUrl: String) {
        self.id = 0
        self.title = title
        self.nutritionInformation = [:]
        self.ingredients = []
        self.servings = 0
        self.prepMinutes = 0
        self.cookMinutes = 0
        self.readyMinutes = 0
        self.imageUrl = imageUrl
    }
    
    func getCalorieNutritionInfo() -> NutritionInfo {
        return nutritionInformation["calories"]!
    }
    
    func getFatNutritionInfo() -> NutritionInfo {
        return nutritionInformation["fat"]!
    }
    
    func getCarbNutritionInfo() -> NutritionInfo {
        return nutritionInformation["carbohydrates"]!
    }
    
    func getProteinNutritionInfo() -> NutritionInfo {
        return nutritionInformation["protein"]!
    }
    
}
