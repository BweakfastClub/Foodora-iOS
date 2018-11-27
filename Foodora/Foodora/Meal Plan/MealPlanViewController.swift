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
        
        SetupTableView()
        
        view.addSubview(emptyTVImage)
        view.addSubview(emptyTVLabel)
        
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
        
        guard let user = NetworkManager.shared.user else {
            debugPrint("Logged in but no user found in Network Manager")
            refreshControl.endRefreshing()
            return
        }
        
        breakfastMeals = user.GetMealPlanBreakfast()
        lunchMeals = user.GetMealPlanLunch()
        dinnerMeals = user.GetMealPlanDinner()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func NoMealPlanData() -> Bool {
        return breakfastMeals.count == 0 && lunchMeals.count == 0 && dinnerMeals.count == 0
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
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
}
