//
//  Meal.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation

struct Meal : Codable {

    
    var id: String
    var mealId: Int
    var title: String
    var nutritionInformation: Dictionary<String, NutritionInfo>
    var ingredients: [Ingredient]
    var servings: Int
    var prepMinutes: Int
    var cookMinutes: Int
    var readyMinutes: Int
    var imageUrl: String
    var userInfo: UserMealInfo?

    init(_ title: String, _ imageUrl: String) {
        self.id = "0"
        self.mealId = 0
        self.title = title
        self.nutritionInformation = [:]
        self.ingredients = []
        self.servings = 0
        self.prepMinutes = 0
        self.cookMinutes = 0
        self.readyMinutes = 0
        self.imageUrl = imageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case mealId = "id"
        case title = "title"
        case servings = "servings"
        case prepMinutes = "prepMinutes"
        case cookMinutes = "cookMinutes"
        case readyMinutes = "readyMinutes"
        case imageUrl = "imageUrl"
        case ingredients = "ingredients"
        case nutritionInformation = "nutrition"
        case userInfo = "userSpecificInformation"
    }
    
    func getCalorieNutritionInfo() -> NutritionInfo? {
        return nutritionInformation["calories"]
    }
    
    func getFatNutritionInfo() -> NutritionInfo? {
        return nutritionInformation["fat"]
    }
    
    func getCarbNutritionInfo() -> NutritionInfo? {
        return nutritionInformation["carbohydrates"]
    }
    
    func getProteinNutritionInfo() -> NutritionInfo? {
        return nutritionInformation["protein"]
    }
    
    func inMealPlan() -> Bool {
        guard let uInfo = userInfo else {
            return false
        }
        
        return uInfo.mealPlan.count > 0
    }
    
    func userLikedRecipe() -> Bool {
        guard let uInfo = userInfo else {
            return false
        }
        return uInfo.hasLiked
    }
    
    static let test_meals : [Meal] = [
        Meal("Chicken Burger", "https://shawarmahotspot.ca/wp-content/uploads/2017/11/Chicken-Burger-325.jpg"),
        Meal("Meat Burger", "https://cms.splendidtable.org/sites/default/files/styles/w2000/public/Burger-Lab_Lamb-Burger-LEDE.jpg"),
        Meal("Cheese Pizza", "https://i.ytimg.com/vi/1pVqlEBmPJU/maxresdefault.jpg"),
        Meal("Chicken Caesar Wrap","https://cdn.schwans.com/media/images/recipes/41276-1-1540.jpg"),
        Meal("Waffle & bananas", "https://d2gk7xgygi98cy.cloudfront.net/1875-3-large.jpg"),
        Meal("Moist Cookies", "https://www.modernhoney.com/wp-content/uploads/2017/11/Thin-and-Crispy-Chocolate-Chip-Cookies-2.jpg"),
        Meal("White Chocolate Chip Cookies", "https://www.peta.org.uk/wp-content/uploads/2017/06/chocorangecookies.jpg"),
        Meal("Chicken Parmesan", "https://assets.epicurious.com/photos/57bdeb19082060f11022b541/2:1/w_1260%2Ch_630/chicken-parmesan.jpg"),
        Meal("Garlic Bread", "https://www.simplyrecipes.com/wp-content/uploads/2006/09/garlic-bread-horiz-a2-1800.jpg"),
        Meal("Sirloin Steak", "https://ae01.alicdn.com/kf/HTB1YSjuHVXXXXcdaXXXq6xXFXXXb/Delicious-food-of-Fruits-Salad-Barbecue-Cafeteria-Kitchen-Decoration-posters-HD-Print-Size-50x70cm-Wall-Sticker.jpg")
    ]
    
}

struct UserMealInfo : Codable {
    var hasLiked: Bool
    var mealPlan: [String]
    
    enum CodingKeys: String, CodingKey {
        case hasLiked = "likedRecipes"
        case mealPlan = "mealPlan"
    }
}
