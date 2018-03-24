//
//  NutritionInfo.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation

struct NutritionInfo: Codable {
    
    var name: String
    var amount: Double
    var unit: String
    var displayValue: String
    var dailyValue: String
    var isCompleteData: Bool
    
}
