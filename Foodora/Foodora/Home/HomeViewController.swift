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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1) {
            let cell = MealTableViewCell_CollectionViewTableViewCell(style: .default, reuseIdentifier: "collectionCell")
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }
        
        let cell = MealTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.meal = Meal.test_meals[((indexPath.section + 1) * indexPath.row) % Meal.test_meals.count]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = MealSectionTableViewHeader(reuseIdentifier: "headerCell")
        switch section {
            case 0:
                headerCell.text = "FAVORITES"
            case 1:
                headerCell.text = "TOP MEALS"
            case 2:
                headerCell.text = "RECOMMENDED BREAKFAST"
            case 3:
                headerCell.text = "RECOMMENDED LUNCH"
            case 4:
                headerCell.text = "RECOMMENDED DINNER"
            default:
                headerCell.text = "RECOMMENDED DINNER"
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
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
        return CGSize(width: (self.view.frame.width / 2.0) - 1.0, height: 130.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("potato")
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
}
