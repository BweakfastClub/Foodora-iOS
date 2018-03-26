//
//  MealViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-25.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealViewController : UIViewController {
    
    var gradient = CAGradientLayer()
    
    private var meal: Meal? {
        didSet {
            UpdateView()
        }
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let mealTitle: UILabel = {
        let label = UILabel()
        label.text = "Meal"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 28)!
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }()
    
    private let nutritionStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let calorieView: NutritionView = NutritionView()
    let proteinView: NutritionView = NutritionView()
    let fatView: NutritionView = NutritionView()
    let carbView: NutritionView = NutritionView()
    
    convenience init(meal: Meal) {
        self.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        self.meal = meal
        
        view.addSubview(imageView)
        view.addSubview(mealTitle)
        view.addSubview(lineView)
        
        view.addSubview(nutritionStack)
        nutritionStack.addArrangedSubview(calorieView)
        nutritionStack.addArrangedSubview(proteinView)
        nutritionStack.addArrangedSubview(fatView)
        nutritionStack.addArrangedSubview(carbView)
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.50, 1]
        imageView.layer.mask = gradient
        
        UpdateView()
        ApplyConstraints()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        gradient.frame = imageView.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func UpdateView() {
        if meal != nil {
            NetworkManager.GetImageByUrl(meal!.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            mealTitle.text = meal!.title
            
//            let calorieInfo = meal!.getCalorieNutritionInfo()
//            calorieView.setNutritionData(calorieInfo.name, "\(calorieInfo.amount) \(calorieInfo.unit)")
            calorieView.setNutritionData("Calories", "635")
            
//            let proteinInfo = meal!.getProteinNutritionInfo()
//            proteinView.setNutritionData(proteinInfo.name, "\(proteinInfo.amount) \(proteinInfo.unit)")
            proteinView.setNutritionData("Protein", "25g")
            
//            let carbInfo = meal!.getCarbNutritionInfo()
//            carbView.setNutritionData(carbInfo.name, "\(carbInfo.amount) \(carbInfo.unit)")
            carbView.setNutritionData("Total Carbs", "73g")
            
//            let fatInfo = meal!.getFatNutritionInfo()
//            fatView.setNutritionData(fatInfo.name, "\(fatInfo.amount) \(fatInfo.unit)")
            fatView.setNutritionData("Total Fat", "12g")
            
        }
    }
    
    private func ApplyConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
        
        mealTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mealTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            mealTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            mealTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
        ])
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            lineView.topAnchor.constraint(equalTo: mealTitle.bottomAnchor, constant: 10),
            lineView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        nutritionStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nutritionStack.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10),
            nutritionStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nutritionStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            nutritionStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
}

class NutritionView: UIView {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let nutritionNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-UltraLight", size: 16)!
        label.text = "calories"
        return label
    }()
    
    private let nutritionAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "1200"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)!
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        stack.addArrangedSubview(nutritionAmountLabel)
        stack.addArrangedSubview(nutritionNameLabel)
        
        ApplyConstraints()
    }
    
    public func setNutritionData(_ nutritionName: String, _ nutritionAmount: String) {
        self.nutritionNameLabel.text = nutritionName
        self.nutritionAmountLabel.text = nutritionAmount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ApplyConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
}
