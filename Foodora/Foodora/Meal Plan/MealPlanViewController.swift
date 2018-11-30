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
    
    private let NUMBER_OF_SECTIONS: Int = 3
    private let CELL_ID: String = "mealCell"
    private let DEFAULT_CELL_HEIGHT : CGFloat = 130.0
    
    private let BREAKFAST_SECTION: Int = 0
    private let LUNCH_SECTION: Int = 1
    private let DINNER_SECTION: Int = 2
    
    private var breakfastMeals: [Meal] = []
    private var lunchMeals: [Meal] = []
    private var dinnerMeals: [Meal] = []
    
    private let refreshControl = UIRefreshControl()
    
    // empty collection view logo
    let emptyTVImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "brain")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // empty collection view label
    let emptyTVLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't added anything yet."
        label.font = UIFont(name: "PingFangHK-Ultralight", size: 20)
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nutritionStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.backgroundColor = Style.main_color
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let calorieView: MealPlanNutritionView = MealPlanNutritionView()
    private let proteinView: MealPlanNutritionView = MealPlanNutritionView()
    private let fatView: MealPlanNutritionView = MealPlanNutritionView()
    private let carbView: MealPlanNutritionView = MealPlanNutritionView()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RetrieveMealPlanInfo()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "MEAL PLAN"
        
        view.addSubview(nutritionStack)
        nutritionStack.addArrangedSubview(calorieView)
        nutritionStack.addArrangedSubview(proteinView)
        nutritionStack.addArrangedSubview(fatView)
        nutritionStack.addArrangedSubview(carbView)
        
        SetupTableView()
        
        view.addSubview(emptyTVImage)
        view.addSubview(emptyTVLabel)
        
        UpdateView()
        ApplyConstraints()
    }
    
    private func RetrieveMealPlanInfo() {
        if (!NetworkManager.shared.IsLoggedIn()) {
            return
        }
        
        guard let user = NetworkManager.shared.user else {
            debugPrint("Logged in but no user found in Network Manager")
            return
        }
        
        breakfastMeals = user.GetMealPlanBreakfast()
        lunchMeals = user.GetMealPlanLunch()
        dinnerMeals = user.GetMealPlanDinner()
    }
    
    private func SetupTableView() {
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(MealPlanViewController.refreshData), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: CELL_ID)
        view.addSubview(tableView)
    }
    
    @objc private func refreshData(_ sender: AnyObject?) {
        if (!NetworkManager.shared.IsLoggedIn()) {
            refreshControl.endRefreshing()
            return
        }
        
        NetworkManager.shared.RetrieveUserData { (statusCode) in
            DispatchQueue.main.async {
                guard let refreshedUser = NetworkManager.shared.user else {
                    self.refreshControl.endRefreshing()
                    return
                }
                self.breakfastMeals = refreshedUser.GetMealPlanBreakfast()
                self.lunchMeals = refreshedUser.GetMealPlanLunch()
                self.dinnerMeals = refreshedUser.GetMealPlanDinner()
                self.tableView.reloadData()
                self.UpdateView()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func NoMealPlanData() -> Bool {
        return breakfastMeals.count == 0 && lunchMeals.count == 0 && dinnerMeals.count == 0
    }
    
    private func UpdateView() {
        if (!NetworkManager.shared.IsLoggedIn()) {
            return
        }
        
        var totalCalories: Int = 0
        var totalProtein: Int = 0
        var totalCarbs: Int = 0
        var totalFats: Int = 0
        
        for breakfast in [breakfastMeals, lunchMeals, dinnerMeals].flatMap({ $0 }) {
            totalCalories += Int(breakfast.getCalorieNutritionInfo()?.amount ?? 0)
            totalProtein += Int(breakfast.getProteinNutritionInfo()?.amount ?? 0)
            totalCarbs += Int(breakfast.getCarbNutritionInfo()?.amount ?? 0)
            totalFats += Int(breakfast.getFatNutritionInfo()?.amount ?? 0)
        }
        
        calorieView.setNutritionData("Calories", "\(totalCalories)")
        proteinView.setNutritionData("Protein", "\(totalProtein)g")
        carbView.setNutritionData("Total Carbs", "\(totalCarbs)g")
        fatView.setNutritionData("Total Fat", "\(totalFats)g")
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nutritionStack.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nutritionStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            nutritionStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            nutritionStack.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nutritionStack.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyTVImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTVImage.widthAnchor.constraint(equalToConstant: 80),
            emptyTVImage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyTVImage.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            emptyTVLabel.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            emptyTVLabel.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            emptyTVLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyTVLabel.topAnchor.constraint(equalTo: emptyTVImage.bottomAnchor, constant: 5)
        ])
    }
    
}


extension MealPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (NoMealPlanData()) {
            
            emptyTVImage.alpha = 1.0
            emptyTVLabel.alpha = 1.0
            
            return 0
        }
        
        emptyTVImage.alpha = 0.0
        emptyTVLabel.alpha = 0.0
        
        switch section {
        case BREAKFAST_SECTION:
            return breakfastMeals.count
        case LUNCH_SECTION:
            return lunchMeals.count
        case DINNER_SECTION:
            return dinnerMeals.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MealTableViewCell
        
        switch indexPath.section {
        case BREAKFAST_SECTION:
            cell.meal = breakfastMeals[indexPath.row]
        case LUNCH_SECTION:
            cell.meal = lunchMeals[indexPath.row]
        case DINNER_SECTION:
            cell.meal = dinnerMeals[indexPath.row]
        default:
            cell.meal = nil
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DEFAULT_CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MealSectionTableViewHeader(reuseIdentifier: "headerCell")
        
        switch section {
        case BREAKFAST_SECTION:
            header.text = "BREAKFAST"
        case LUNCH_SECTION:
            header.text = "LUNCH"
        case DINNER_SECTION:
            header.text = "DINNER"
        default:
            header.text = ""
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (NoMealPlanData()) {
            return 0.0
        }
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMeal: Meal
        
        switch indexPath.section {
        case 0:
            selectedMeal = breakfastMeals[indexPath.row]
        case 1:
            selectedMeal = lunchMeals[indexPath.row]
        case 2:
            selectedMeal = dinnerMeals[indexPath.row]
        default:
            return
        }
        
        let mealVC = MealViewController(meal: selectedMeal)
        self.navigationController?.pushViewController(mealVC, animated: true)
    }
}


fileprivate class MealPlanNutritionView: UIView {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let nutritionNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Style.LIGHT_WHITE
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)!
        label.text = "calories"
        return label
    }()
    
    private let nutritionAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "1200"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)!
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Style.main_color
        
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
            stack.heightAnchor.constraint(equalToConstant: 40),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
}
