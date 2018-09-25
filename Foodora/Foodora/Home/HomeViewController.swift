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
    
    private let NUMBER_OF_SECTIONS = 3
    private let FAV_MEALS_INDEX = 0
    private let TOP_MEALS_INDEX = 1
    private let RECOMMENDED_MEAL_INDEX = 2
    
    private let DEFAULT_CELL_HEIGHT : CGFloat = 130.0
    
    private var NUMBER_OF_FAV_MEALS = 6
    private var NUMBER_OF_TOP_MEALS = 4
    
    let tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup cell dynamic row height
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 130.0
        
        tv.separatorStyle = .none
        tv.sectionHeaderHeight = 40
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "BRAINFOOD"
        
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "circle-user"), style: .plain, target: self, action: #selector(self.OpenProfileView))
        leftButton.tintColor = Style.main_color
        self.navigationItem.leftBarButtonItem = leftButton
        
        SetupTableView()
        
        ApplyConstraints()
    }
    
    private func SetupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func OpenProfileView() {
        print("Opening Profile view")
    }
    
    private func ApplyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case TOP_MEALS_INDEX:
            return (ceil(CGFloat(NUMBER_OF_TOP_MEALS) / 2.0)) * DEFAULT_CELL_HEIGHT + ((CGFloat(NUMBER_OF_TOP_MEALS)/2.0) - 1.0)
        case FAV_MEALS_INDEX:
            return (ceil(CGFloat(NUMBER_OF_FAV_MEALS) / 2.0)) * DEFAULT_CELL_HEIGHT + ((CGFloat(NUMBER_OF_FAV_MEALS)/2.0) - 1.0)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == TOP_MEALS_INDEX || section == FAV_MEALS_INDEX) {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == TOP_MEALS_INDEX || indexPath.section == FAV_MEALS_INDEX) {
            let cell = MealTableViewCell_CollectionViewTableViewCell(style: .default, reuseIdentifier: "collectionCell")
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
            return cell
        }
        
        let cell = MealTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.meal = Meal.test_meals[((indexPath.section + 1) * indexPath.row) % Meal.test_meals.count]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = MealSectionTableViewHeader(reuseIdentifier: "headerCell")
        switch section {
            case FAV_MEALS_INDEX:
                headerCell.text = "FAVORITES"
            case TOP_MEALS_INDEX:
                headerCell.text = "TOP MEALS"
            case RECOMMENDED_MEAL_INDEX:
                headerCell.text = "RECOMMENDED MEALS"
            default:
                headerCell.text = "RECOMMENDED MEALS"
        }
        return headerCell
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
        case FAV_MEALS_INDEX:
            return NUMBER_OF_FAV_MEALS
        case TOP_MEALS_INDEX:
            return NUMBER_OF_TOP_MEALS
        default:
            print("Unkwown collectionView with tag: \(collectionView.tag)")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ImageCollectionViewCell
        cell.meal = Meal.test_meals[indexPath.row % Meal.test_meals.count]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case FAV_MEALS_INDEX:
            NUMBER_OF_FAV_MEALS -= 1
            tableView.reloadData()
        case TOP_MEALS_INDEX:
            NUMBER_OF_TOP_MEALS -= 1
            tableView.reloadData()
        default:
            return
        }
    }
}
