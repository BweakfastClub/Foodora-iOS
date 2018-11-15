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
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "MEAL PLAN"
        
        SetupTableView()
        
        ApplyConstraints()
    }
    
    private func SetupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: CELL_ID)
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])
    }
    
}


extension MealPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MealTableViewCell
        cell.meal = Meal.test_meals[indexPath.section + indexPath.row % Meal.test_meals.count]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DEFAULT_CELL_HEIGHT
    }
}
