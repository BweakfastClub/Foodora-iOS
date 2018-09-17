//
//  MealSelectionViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealSelectionViewController : UIViewController {
    
    private var meals: [Meal] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var viewTitle: String = "" {
        didSet {
            self.navigationController?.navigationBar.topItem?.title = viewTitle
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let searchBar : UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search Recipes"
        search.sizeToFit()
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        SetupCollectionView()
        PopulateMeals()
        ApplyConstraints()
    }
    
    private func PopulateMeals() {
        
        meals.append(Meal("Can't Wait Microwave Lava Cake", "https://images.media-allrecipes.com/userphotos/4510959.jpg"))
        meals.append(Meal("Chicken Tetrazzini", "https://images.media-allrecipes.com/userphotos/466448.jpg"))
        meals.append(Meal("Chicken Marsala Over White Rice", "https://images.media-allrecipes.com/userphotos/1448794.jpg"))
        meals.append(Meal("Moroccan Chicken Tagine with Caramelized Pears", "https://images.media-allrecipes.com/userphotos/4731893.jpg"))
        meals.append(Meal("Rice with other stuff", "https://fthmb.tqn.com/JdhMTBO9_i1Z7pmL74t7VyKiUFM=/3604x2766/filters:fill(auto,1)/GettyImages-184989995-56b38fd03df78cf7385cbcbb.jpg"))
        meals.append(Meal("Tender Italian Baked Chicken", "https://images.media-allrecipes.com/userphotos/4536524.jpg"))
        meals.append(Meal("Roast Chicken with Thyme and Onions", "https://images.media-allrecipes.com/userphotos/211414.jpg"))
        meals.append(Meal("Chicken Divan Casserole", "https://images.media-allrecipes.com/userphotos/4588683.jpg"))
        meals.append(Meal("Thai Chicken with Basil Stir Fry", "https://images.media-allrecipes.com/userphotos/2677.jpg"))
        meals.append(Meal("Chicken Pot Pie", "https://images.media-allrecipes.com/userphotos/4535759.jpg"))
        meals.append(Meal("Slow Cooker Chicken and Dumplings", "https://images.media-allrecipes.com/userphotos/806223.jpg"))
        meals.append(Meal("Baked Teriyaki Chicken", "https://images.media-allrecipes.com/userphotos/4530047.jpg"))
    }
    
    private func SetupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: "mealcell")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCellId")
        searchBar.delegate = self
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
    }
    
}

extension MealSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealcell", for: indexPath) as! MealCollectionViewCell
        
        let meal = meals[indexPath.row]
        cell.meal = meal
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width / 2.0)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        let mealVC = MealViewController(meal: meal)
        self.navigationController?.pushViewController(mealVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCellId", for: indexPath)
        header.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
    
}

extension MealSelectionViewController: UISearchBarDelegate {
    
}
