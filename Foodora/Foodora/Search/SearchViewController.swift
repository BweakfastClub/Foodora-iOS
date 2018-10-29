//
//  SearchViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-04.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController {
    
    private let CELL_ID: String = "mealCell"
    private let DEFAULT_CELL_HEIGHT : CGFloat = 130.0
    
    // View that contains search bar
    let searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // search bar
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.backgroundImage = UIImage()
        
        sb.setPlaceholderTextColorTo(color: Style.main_color)
        sb.setMagnifyingGlassColorTo(color: Style.main_color)
        sb.setSearchFieldBackgroundColor(color: Style.LIGHT_GRAY)
        
        return sb
    }()
    
    let mealCollectionView: UICollectionView = {
        var layout : UICollectionViewLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Style.LIGHT_GRAY
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "SEARCH"
        
        // Setup search bar delegate
        searchBar.delegate = self
        
        // Search bar
        view.addSubview(searchBar)
        
        // Meal collection view
        mealCollectionView.dataSource = self
        mealCollectionView.delegate = self
        mealCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        view.addSubview(mealCollectionView)
        
        ApplyConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func ApplyConstraints() {
        
        // Search bar constraints
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        // Meal Collection View
        NSLayoutConstraint.activate([
            mealCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mealCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mealCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mealCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    
}

extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // cell bottom padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    // cell side padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: DEFAULT_CELL_HEIGHT)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ImageCollectionViewCell
        cell.meal = Meal.test_meals[indexPath.row % Meal.test_meals.count]
        return cell
    }
}

extension SearchViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = Meal.test_meals[indexPath.row % Meal.test_meals.count]
        let mealVC = MealViewController(meal: meal)
        self.navigationController?.pushViewController(mealVC, animated: true)
    }
}
