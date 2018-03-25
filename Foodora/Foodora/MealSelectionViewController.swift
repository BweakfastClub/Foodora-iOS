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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        SetupCollectionView()
        PopulateMeals()
        ApplyConstraints()
    }
    
    private func PopulateMeals() {
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://4.bp.blogspot.com/-qXlf-A0Pwx8/UXiCteiPs2I/AAAAAAAAs4I/Boe1rU198o8/s1600/Food+HD+Wallpapers+(2).jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://wallpapersdsc.net/wp-content/uploads/2016/09/Junk-Food-Pictures.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://s-media-cache-ak0.pinimg.com/originals/f9/d1/94/f9d194edc227bc3f3881c5530c5c7624.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://cdn.wallpapersafari.com/82/16/jI26l9.jpg"))
        
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm4cY1hUSW3VC9EzzZhy8SKj-L-TRSZoaoTctNohbjkgbcg57a"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://s3.amazonaws.com/etntmedia/media/images/ext/842849976/greasy-fast-food.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2017/11/chocolate_cake.jpg?itok=s7oiyPuG&fc=50,50"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://fthmb.tqn.com/JdhMTBO9_i1Z7pmL74t7VyKiUFM=/3604x2766/filters:fill(auto,1)/GettyImages-184989995-56b38fd03df78cf7385cbcbb.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://4.bp.blogspot.com/-qXlf-A0Pwx8/UXiCteiPs2I/AAAAAAAAs4I/Boe1rU198o8/s1600/Food+HD+Wallpapers+(2).jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://wallpapersdsc.net/wp-content/uploads/2016/09/Junk-Food-Pictures.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://s-media-cache-ak0.pinimg.com/originals/f9/d1/94/f9d194edc227bc3f3881c5530c5c7624.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://cdn.wallpapersafari.com/82/16/jI26l9.jpg"))
        
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm4cY1hUSW3VC9EzzZhy8SKj-L-TRSZoaoTctNohbjkgbcg57a"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://s3.amazonaws.com/etntmedia/media/images/ext/842849976/greasy-fast-food.jpg"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2017/11/chocolate_cake.jpg?itok=s7oiyPuG&fc=50,50"))
        meals.append(Meal(id: 0, title: "MEAL 1", nutritionInformation: [:], ingredients: [], servings: 0, prepMinutes: 0, cookMinutes: 0, readyMinutes: 0, imageUrl: "https://fthmb.tqn.com/JdhMTBO9_i1Z7pmL74t7VyKiUFM=/3604x2766/filters:fill(auto,1)/GettyImages-184989995-56b38fd03df78cf7385cbcbb.jpg"))
    }
    
    private func SetupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: "mealcell")
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
    
}
