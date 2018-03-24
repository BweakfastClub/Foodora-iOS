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

}
