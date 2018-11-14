//
//  SettingsViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-11-13.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Settings View", attributes: [
            NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 34)!,
            NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        label.textAlignment = .center
        return label
    }()
    
    var logoutButton: BetterButton = {
        let button = BetterButton()
        button.setTitle("LOGOUT", for: .normal)
        button.backgroundColor = Style.main_color
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(MealViewController.clickedMealPlanButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(navigationController?.navigationBar)
        self.title = "SETTINGS"
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        view.addSubview(logoutButton)
        
        ApplyConstraints()
    }
    
    private func ApplyConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Title label constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
