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
    
    private var meal: Meal? {
        didSet {
            UpdateView()
        }
    }
    
    var dismissButton : UIButton = {
        let button = BetterButton()
        let label = UILabel()
        button.titleLabel?.font = UIFont(name: "fontawesome", size: 30)
        button.setTitle("\u{f104}", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(MealViewController.dismissView), for: .touchUpInside)
        return button
    }()
    
    var likeRecipeButton: UIButton = {
        let button = BetterButton()
        let label = UILabel()
        button.titleLabel?.font = UIFont(name: "fontawesome", size: 20)
        button.setTitle("\u{f004}", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(MealViewController.likeMeal), for: .touchUpInside)
        return button
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Adding fade to image
        let fadeView = UIView()
        view.addSubview(fadeView)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.35
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fadeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            fadeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            fadeView.topAnchor.constraint(equalTo: view.topAnchor),
            fadeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private let mealTitle: UILabel = {
        let label = UILabel()
        label.text = "Meal"
        label.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nutritionalFactLabel: UILabel = {
        let label = UILabel()
        label.text = "NUTRITIONAL FACTS"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)!
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nutritionStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ingredientTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "INGREDIENTS"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)!
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func ingredientLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)!
        label.textColor = Style.GRAY
        label.textColor = .black
        label.textAlignment = .left
        return label
    }
    
    private let calorieView: NutritionView = NutritionView()
    private let proteinView: NutritionView = NutritionView()
    private let fatView: NutritionView = NutritionView()
    private let carbView: NutritionView = NutritionView()
    
    private var likedMeal: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.UpdateLikeButton()
            }
        }
    }
    
    private var inMealPlan: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.UpdateMealPlanButton()
            }
        }
    }
    
    var mealPlanButton: BetterButton = {
        let button = BetterButton()
        button.setTitle("ADD TO MEAL PLAN", for: .normal)
        button.backgroundColor = Style.main_color
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(MealViewController.clickedMealPlanButton), for: .touchUpInside)
        return button
    }()
    
    var ingredientTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 30
        return view
    }()
    
    convenience init(meal: Meal) {
        self.init(nibName: nil, bundle: nil)
        self.meal = meal
        RetrieveMeal(meal.mealId)
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(mealTitle)
        
        view.addSubview(nutritionalFactLabel)
        view.addSubview(nutritionStack)
        nutritionStack.addArrangedSubview(calorieView)
        nutritionStack.addArrangedSubview(proteinView)
        nutritionStack.addArrangedSubview(fatView)
        nutritionStack.addArrangedSubview(carbView)
        
        view.addSubview(ingredientTitleLabel)
        
        //view.addSubview(ingredientStack)
        view.addSubview(ingredientTableView)
        
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        
        view.addSubview(mealPlanButton)
        
        view.addSubview(dismissButton)
        
        view.addSubview(likeRecipeButton)
        
        UpdateView()
        ApplyConstraints()
    }
    
    private func RetrieveMeal(_ mealId: Int) {
        NetworkManager.shared.GetRecipeById(mealId) { (meal) in
            DispatchQueue.main.async {
                guard let m = meal else { return }
                self.meal = m
                self.likedMeal = m.userLikedRecipe()
                self.inMealPlan = m.inMealPlan()
            }
        }
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
    
    @IBAction private func dismissView(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // like button clicked
    @IBAction private func likeMeal(sender: UIButton) {
        guard let m = meal else { return }
        NetworkManager.shared.LikeMeals([m.mealId], !self.likedMeal) { (success) in
            print("Success: \(success)")
            if (success) {
                DispatchQueue.main.async {
                    self.likedMeal = !self.likedMeal
                    self.UpdateLikeButton()
                }
            }
        }
    }
    
    private func UpdateLikeButton() {
        if !NetworkManager.shared.IsLoggedIn() { return }
        if (self.likedMeal) {
            likeRecipeButton.setTitleColor(Style.NICE_RED, for: .normal)
        } else {
            likeRecipeButton.setTitleColor(.white, for: .normal)
        }
        self.likeRecipeButton.setNeedsDisplay()
    }
    
    @IBAction private func clickedMealPlanButton(sender: UIButton) {
        guard let m = meal else { return }
        
        if (self.inMealPlan) {
            AttemptingToRemoveFromMealPlan()
        } else {
            AttemptingToAddToMealPlan()
        }
    }
    
    private func AttemptingToAddToMealPlan() {
        guard let m = meal else { return }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let attributedTitle = NSAttributedString(string: "Add To Meal Plan", attributes: [NSAttributedStringKey.font : UIFont(name: "AvenirNext-DemiBold", size: 20)!])
        let attributedMessage = NSAttributedString(string: "Which meal is this?", attributes: [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Medium", size: 16)!])
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let breakfastAction = UIAlertAction(title: "Breakfast", style: .default, handler: { (action) -> Void in
            self.AddToMealPlan(meal: m, mealType: "breakfast")
        })
        
        let lunchAction = UIAlertAction(title: "Lunch", style: .default, handler: { (action) -> Void in
            self.AddToMealPlan(meal: m, mealType: "lunch")
        })
        
        let dinnerAction = UIAlertAction(title: "Dinner", style: .default, handler: { (action) -> Void in
            self.AddToMealPlan(meal: m, mealType: "dinner")
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            return
        })
        
        alert.addAction(breakfastAction)
        alert.addAction(lunchAction)
        alert.addAction(dinnerAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func AttemptingToRemoveFromMealPlan() {
        guard let m = meal else { return }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let attributedTitle = NSAttributedString(string: "Remove From Meal Plan", attributes: [NSAttributedStringKey.font : UIFont(name: "AvenirNext-DemiBold", size: 20)!])
        let attributedMessage = NSAttributedString(string: "Are you sure?", attributes: [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Medium", size: 16)!])
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.RemoveFromMealPlan(meal: m)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            return
        })
        
        alert.addAction(confirmAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func AddToMealPlan(meal: Meal, mealType: String) {
        debugPrint("Adding \(meal.title) to \(mealType) meal plan")
        
        guard let u = NetworkManager.shared.user else {
            debugPrint("Failed to get user from network manager.")
            return
        }
        
        u.AddTopMealPlan(mealToAdd: meal, typeOfMeal: mealType) { (success) in
            if (success) {
                debugPrint("SUCCESS: Adding \(meal.title) to \(mealType) meal plan")
                self.inMealPlan = !self.inMealPlan
            } else {
                debugPrint("FAILED: Adding \(meal.title) to \(mealType) meal plan")
            }
        }
    }
    
    private func RemoveFromMealPlan(meal: Meal) {
        debugPrint("Removing \(meal.title) from meal plan")
        
        guard let u = NetworkManager.shared.user else {
            debugPrint("Failed to get user from network manager.")
            return
        }
        
        u.RemoveFromMealPlan(mealToAdd: meal) { (success) in
            if (success) {
                debugPrint("SUCCESS: Removed \(meal.title) from meal plan")
                self.inMealPlan = !self.inMealPlan
            } else {
                debugPrint("FAILED: Removed \(meal.title) from meal plan")
            }
        }
    }
    
    private func UpdateView() {
        if (!NetworkManager.shared.IsLoggedIn()) {
            likeRecipeButton.alpha = 0.0
            likeRecipeButton.isUserInteractionEnabled = false
        }
        
        if meal != nil {
            NetworkManager.shared.GetImageByUrl(meal!.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            mealTitle.text = meal!.title.uppercased()
            
            UpdateMealPlanButton()
            
            let calorieInfo = meal!.getCalorieNutritionInfo()
            if (calorieInfo != nil) {
                calorieView.setNutritionData("Calories", "\(calorieInfo!.amount.rounded())\(calorieInfo!.unit)")
            }
            
            let proteinInfo = meal!.getProteinNutritionInfo()
            if (proteinInfo != nil) {
                proteinView.setNutritionData("Protein", "\(proteinInfo!.amount.rounded())\(proteinInfo!.unit)")
            }
            
            let carbInfo = meal!.getCarbNutritionInfo()
            if (carbInfo != nil) {
                carbView.setNutritionData("Total Carbs", "\(carbInfo!.amount.rounded())\(carbInfo!.unit)")
            }
            
            let fatInfo = meal!.getFatNutritionInfo()
            if (fatInfo != nil) {
                fatView.setNutritionData("Total Fat", "\(fatInfo!.amount.rounded())\(fatInfo!.unit)")
            }
            
            for ingredient in meal!.ingredients {
                let tempLabel = ingredientLabel()
                tempLabel.text = ingredient.description
                ingredientStack.addArrangedSubview(tempLabel)
            }
            
        }
    }
    
    private func UpdateMealPlanButton() {
        if (!NetworkManager.shared.IsLoggedIn()) {
            mealPlanButton.alpha = 0.0
            mealPlanButton.isUserInteractionEnabled = false
            return
        }
        
        mealPlanButton.alpha = 1.0
        mealPlanButton.isUserInteractionEnabled = true
        
        if (self.inMealPlan) {
            mealPlanButton.setTitle("REMOVE FROM MEAL PLAN", for: .normal)
            mealPlanButton.backgroundColor = Style.NICE_RED
        } else {
            mealPlanButton.setTitle("ADD TO MEAL PLAN", for: .normal)
            mealPlanButton.backgroundColor = Style.main_color
        }
    }
    
    private func ApplyConstraints() { //TODO: PUT EVERYTHING IN A STACK VIEW OR TRY AND USE A TABLEVIEW FOR INGREDIENTS
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dismissButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            likeRecipeButton.widthAnchor.constraint(equalToConstant: 30),
            likeRecipeButton.heightAnchor.constraint(equalToConstant: 30),
            likeRecipeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            likeRecipeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30)
        ])
        
        mealTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mealTitle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            mealTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            mealTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            nutritionalFactLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nutritionalFactLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nutritionalFactLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nutritionStack.topAnchor.constraint(equalTo: nutritionalFactLabel.bottomAnchor, constant: 10),
            nutritionStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nutritionStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            nutritionStack.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            ingredientTitleLabel.topAnchor.constraint(equalTo: nutritionStack.bottomAnchor, constant: 10),
            ingredientTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            ingredientTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        
//        NSLayoutConstraint.activate([
//            ingredientStack.topAnchor.constraint(equalTo: ingredientTitleLabel.bottomAnchor, constant: 10),
//            ingredientStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            ingredientStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
//        ])
        
        NSLayoutConstraint.activate([
            mealPlanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            mealPlanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealPlanButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80),
            mealPlanButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            ingredientTableView.topAnchor.constraint(equalTo: ingredientTitleLabel.bottomAnchor, constant: 10),
            ingredientTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            ingredientTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            ingredientTableView.bottomAnchor.constraint(equalTo: mealPlanButton.topAnchor, constant: -5)
        ])
        
    }
    
}

extension MealViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let m = meal else { return 0 }
        
        return m.ingredients.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(frame: .zero)
        
        guard let m = meal  else { return cell }
        cell.textLabel?.text = m.ingredients[indexPath.row].description
        
        return cell
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
        label.textColor = Style.GRAY
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)!
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
