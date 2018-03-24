//
//  BrowseViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class BrowseViewController : UIViewController {
    
    private var breakfastCell: BrowseOptionView!
    private var lunchCell: BrowseOptionView!
    private var dinnerCell: BrowseOptionView!
    private var snacksCell: BrowseOptionView!
    
    private let mainStack: UIStackView = {
        let view = UIStackView()
        view.spacing = 10.0
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "BROWSE"
        
        view.addSubview(mainStack)
        
        breakfastCell = BrowseOptionView("https://images5.alphacoders.com/432/432498.jpg", "BREAKFAST")
        mainStack.addArrangedSubview(breakfastCell)

        lunchCell = BrowseOptionView("https://images6.alphacoders.com/609/609345.jpg", "LUNCH")
        mainStack.addArrangedSubview(lunchCell)
        
        dinnerCell = BrowseOptionView("https://imgur.com/yQbH8Yk.png", "DINNER")
        mainStack.addArrangedSubview(dinnerCell)
        
        snacksCell = BrowseOptionView("https://imgur.com/x7nGYB8.png", "SNACKS")
        mainStack.addArrangedSubview(snacksCell)
        
        ApplyConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func ApplyConstraints() {
        let safeMargin = view.safeAreaLayoutGuide
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeMargin.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: safeMargin.bottomAnchor, constant: -10),
            mainStack.leftAnchor.constraint(equalTo: safeMargin.leftAnchor, constant: 20),
            mainStack.rightAnchor.constraint(equalTo: safeMargin.rightAnchor, constant: -20)
        ])
    }
    
}

