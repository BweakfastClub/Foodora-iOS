//
//  HomeViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-04.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    private let NUMBER_OF_SECTIONS = 2
    private let RECOMMENDED_MEAL_INDEX = 0
    private let TOP_MEALS_INDEX = 1
    
    private let DEFAULT_CELL_HEIGHT : CGFloat = 130.0
    
    private var recommendedMeals: [Meal] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var topMeals: [Meal] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup cell dynamic row height
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 130.0
        
        tv.separatorStyle = .none
        return tv
    }()
    
    let infoLabel : UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "AvenirNext-Bold", size: 16)!
        l.textColor = .white
        l.textAlignment = .center
        l.text = "Doesn't seem like you're logged in..."
        
        return l
    }()
    
    let infoView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.main_color
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "BRAINFOOD"
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(self.OpenProfileView))
        leftButton.tintColor = Style.main_color
        self.navigationItem.leftBarButtonItem = leftButton
        
        RequestTopMeals()
        SetupTableView()
        SetupInfoView()
        ApplyConstraints()
    }
    
    private func SetupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func SetupInfoView() {
        infoView.addSubview(infoLabel)
        if (NetworkManager.IsLoggedIn()) {
            infoView.backgroundColor = .white
            infoLabel.text = """
            Welcome back Brandon!
            In the mood for some breakfast ideas?
            """
            infoLabel.numberOfLines = 2
            infoLabel.textColor = Style.GRAY
            infoLabel.alpha = 0.50
        }
        view.addSubview(infoView)
    }
    
    private func RequestTopMeals() {
        NetworkManager.TopRecipes { (mealRes) in
            guard let meals = mealRes else { return }
            DispatchQueue.main.async {
                self.topMeals = meals
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if (NetworkManager.IsLoggedIn()) { //TODO: check if we actually need to update
                self.ApplyConstraints()
                self.SetupInfoView()
                self.tableView.reloadData()
                self.view.setNeedsDisplay()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func OpenProfileView() {
        self.navigationController?.present(UINavigationController(rootViewController: LoginViewController()), animated: true, completion:  nil)
    }
    
    private func ApplyConstraints() {
        let safeLayout = view.safeAreaLayoutGuide
        
        // Removing infoView/infoLabel constraints
        infoView.removeConstraints(infoView.constraints)
        infoLabel.removeConstraints(infoLabel.constraints)
        
        // info view
        NSLayoutConstraint.activate([
            infoLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor),
            infoLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            infoView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            infoView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor)
        ])

        if (!NetworkManager.IsLoggedIn()) {
            infoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            infoLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            infoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor)
        ])
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == RECOMMENDED_MEAL_INDEX) {
            if (!NetworkManager.IsLoggedIn()) {
                return 0
            }
            return DEFAULT_CELL_HEIGHT
        } else {
            return (ceil(CGFloat(topMeals.count) / 2.0)) * DEFAULT_CELL_HEIGHT + ((CGFloat(topMeals.count)/2.0) - 1.0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MealTableViewCellWithCollectionView
        if (indexPath.section == RECOMMENDED_MEAL_INDEX) {
            cell = MealTableViewCellWithCollectionView(style: .default, reuseIdentifier: "recommendedCell", scrollDirection: .horizontal)
        }
        
        cell = MealTableViewCellWithCollectionView(style: .default, reuseIdentifier: "topMealCell", scrollDirection: .vertical)
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = MealSectionTableViewHeader(reuseIdentifier: "headerCell")
        switch section {
            case TOP_MEALS_INDEX:
                headerCell.text = "TOP MEALS"
            case RECOMMENDED_MEAL_INDEX:
                headerCell.text = "RECOMMENDED MEALS"
            default:
                headerCell.text = ""
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == RECOMMENDED_MEAL_INDEX && !NetworkManager.IsLoggedIn()) {
            return 0.0
        }
        return 40.0
    }
    
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // cell bottom padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // cell side padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width / 2.0) - 1.0, height: DEFAULT_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case RECOMMENDED_MEAL_INDEX:
            return recommendedMeals.count
        case TOP_MEALS_INDEX:
            return topMeals.count
        default:
            print("Unkwown collectionView with tag: \(collectionView.tag)")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseIdentifier : String
        
        switch collectionView.tag {
        case RECOMMENDED_MEAL_INDEX:
            reuseIdentifier = "recommendedCell"
        case TOP_MEALS_INDEX:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topMealCell", for: indexPath) as! ImageCollectionViewCell
            cell.meal = topMeals[indexPath.row]
            return cell
        default:
            print("Unkwown collectionView with tag: \(collectionView.tag)")
            reuseIdentifier = "collectionCell"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.meal = Meal.test_meals[indexPath.row % Meal.test_meals.count]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var meal : Meal
        print("Section: \(collectionView.tag) Row: \(indexPath.row)")
        switch collectionView.tag {
        case RECOMMENDED_MEAL_INDEX:
            meal = recommendedMeals[indexPath.row]
        case TOP_MEALS_INDEX:
            meal = topMeals[indexPath.row]
        default:
            meal = topMeals[indexPath.row]
        }
        
        let mealVC = MealViewController(meal: meal)
        self.navigationController?.pushViewController(mealVC, animated: true)
        
    }
}
