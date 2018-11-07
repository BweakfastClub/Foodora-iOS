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
    
    private var mealResults: [Meal] = []
    
    // empty collection view logo
    let emptyCVImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "brain")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // empty collection view label
    let emptyCVLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't searched anything"
        label.font = UIFont(name: "PingFangHK-Ultralight", size: 20)
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        searchBar.showsCancelButton = false
        
        // Search bar
        view.addSubview(searchBar)
        
        // Meal collection view
        mealCollectionView.dataSource = self
        mealCollectionView.delegate = self
        mealCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        view.addSubview(mealCollectionView)
        
        // Adding empty view logo
        view.addSubview(emptyCVImage)
        
        // Adding empty view label
        view.addSubview(emptyCVLabel)
        
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
        
        NSLayoutConstraint.activate([
            emptyCVImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCVImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCVImage.centerXAnchor.constraint(equalTo: mealCollectionView.centerXAnchor),
            emptyCVImage.centerYAnchor.constraint(equalTo: mealCollectionView.centerYAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            emptyCVLabel.leftAnchor.constraint(equalTo: mealCollectionView.leftAnchor),
            emptyCVLabel.rightAnchor.constraint(equalTo: mealCollectionView.rightAnchor),
            emptyCVLabel.centerXAnchor.constraint(equalTo: mealCollectionView.centerXAnchor),
            emptyCVLabel.topAnchor.constraint(equalTo: emptyCVImage.bottomAnchor, constant: 5)
        ])
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                searchBar.resignFirstResponder()
                self.mealResults = [] //Remove resulting meals
                self.mealCollectionView.reloadData()
            }
            return
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        NetworkManager.Search(query) { (mealRes) in
            guard let meals = mealRes else { return }
            self.mealResults = meals
            DispatchQueue.main.async {
                self.mealCollectionView.reloadData()
            }
        }
        searchBar.endEditing(true)
    }
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
        if (mealResults.count == 0) {
            emptyCVImage.alpha = 1.0
            emptyCVLabel.alpha = 1.0
            return 0
        }
        emptyCVImage.alpha = 0.0
        emptyCVLabel.alpha = 0.0
        return mealResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ImageCollectionViewCell
        cell.meal = mealResults[indexPath.row]
        return cell
    }
}

extension SearchViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = mealResults[indexPath.row]
        let mealVC = MealViewController(meal: meal)
        self.navigationController?.pushViewController(mealVC, animated: true)
    }
}
