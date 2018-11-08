//
//  Ingredient.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation

struct Ingredient : Codable {
    
    var id: Int
    var description: String
    var grams: Float
    var displayType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ingredientID"
        case description = "displayValue"
        case grams = "grams"
        case displayType = "displayType"
    }
    
}
