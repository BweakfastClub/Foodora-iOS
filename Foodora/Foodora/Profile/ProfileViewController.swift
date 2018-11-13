//
//  ProfileViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-04.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
    
    private let CELL_ID: String = "favMealCell"
    private let DEFAULT_CELL_HEIGHT : CGFloat = 130.0
    
    private var favMeals: [Meal] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let infoView : UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let infoLabel : UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "AvenirNext-Bold", size: 16)!
        l.textColor = .white
        l.textAlignment = .center
        l.numberOfLines = 2
        l.alpha = 0.50
        l.text = "Here are some of your favourite meals!"
        l.textColor = Style.GRAY
        return l
    }()
    
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
        label.text = "You haven't liked anything"
        label.font = UIFont(name: "PingFangHK-Ultralight", size: 20)
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        var layout : UICollectionViewLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Style.LIGHT_GRAY
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "PROFILE"
        
        // Left Nav bar cancel button
        let leftButton = UIBarButtonItem(image: UIImage(named: "clear-cancel"), style: .plain, target: self, action: #selector(ProfileViewController.DismissView))
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftButton
        
        // Right Nav bar settings button
        let rightButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(ProfileViewController.OpenSettings))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        
        // Meal collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        view.addSubview(collectionView)
        
        // info view
        infoView.addSubview(infoLabel)
        view.addSubview(infoView)
        
        // Adding empty view logo
        view.addSubview(emptyCVImage)
        
        // Adding empty view label
        view.addSubview(emptyCVLabel)
        
        ApplyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PullUserData()
    }

    private func PullUserData() {
        NetworkManager.shared.RetrieveUserData { (resStatus) in
            DispatchQueue.main.async {
                guard let u = NetworkManager.shared.user, let meals = u.likedRecipes else {
                    self.favMeals = []
                    return
                }
                self.favMeals = meals
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func DismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func OpenSettings() {
        
    }
    
    private func ApplyConstraints() {
        let safeLayout = view.safeAreaLayoutGuide
        
        // info view
        NSLayoutConstraint.activate([
            infoLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor),
            infoLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            infoView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            infoView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 70),
            infoLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Meal Collection View
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyCVImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCVImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCVImage.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyCVImage.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            emptyCVLabel.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
            emptyCVLabel.rightAnchor.constraint(equalTo: collectionView.rightAnchor),
            emptyCVLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyCVLabel.topAnchor.constraint(equalTo: emptyCVImage.bottomAnchor, constant: 5)
        ])
    }
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        if (favMeals.count == 0) {
            emptyCVImage.alpha = 1.0
            emptyCVLabel.alpha = 1.0
            return 0
        }
        emptyCVImage.alpha = 0.0
        emptyCVLabel.alpha = 0.0
        return favMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ImageCollectionViewCell
        cell.meal = favMeals[indexPath.row]
        return cell
    }
}

extension ProfileViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = favMeals[indexPath.row]
        let mealVC = MealViewController(meal: meal)
        self.navigationController?.pushViewController(mealVC, animated: true)
    }
}
