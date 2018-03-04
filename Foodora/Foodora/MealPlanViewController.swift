//
//  MealPlanViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-04.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealPlanViewController : UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Meal Plan View", attributes: [
            NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 34)!,
            NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        ApplyConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // Title label constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
}

