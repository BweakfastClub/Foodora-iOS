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
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case likedRecipes = "likedRecipes"
    }
    
}
