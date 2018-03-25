//
//  MealCollectionViewCell.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    
    private var meal: Meal? {
        didSet {
            UpdateCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func UpdateCell() {
        
    }
    
}
