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
    private let RECOMMENDED_MEAL_INDEX = 1
    private let TOP_MEALS_INDEX = 2
    
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
        return tv
    }()
    
    let infoLabel : UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "AvenirNext-Bold", size: 16)!
        l.textColor = .white
        l.textAlignment = .center
        l.text = "Doesn't seem like you're logged it..."
        
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
        
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "circle-user"), style: .plain, target: self, action: #selector(self.OpenProfileView))
        leftButton.tintColor = Style.main_color
        self.navigationItem.leftBarButtonItem = leftButton
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func OpenProfileView() {
        self.navigationController?.present(UINavigationController(rootViewController: LoginViewController()), animated: true, completion: {
            // Verify if we logged in or not.
        })
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
        switch indexPath.section {
        case RECOMMENDED_MEAL_INDEX:
//            return (ceil(CGFloat(NUMBER_OF_TOP_MEALS) / 2.0)) * DEFAULT_CELL_HEIGHT + ((CGFloat(NUMBER_OF_TOP_MEALS)/2.0) - 1.0)
            return DEFAULT_CELL_HEIGHT
        case FAV_MEALS_INDEX:
//            return (ceil(CGFloat(NUMBER_OF_FAV_MEALS) / 2.0)) * DEFAULT_CELL_HEIGHT + ((CGFloat(NUMBER_OF_FAV_MEALS)/2.0) - 1.0)
            return DEFAULT_CELL_HEIGHT
        default:
            
            return (ceil(CGFloat(10) / 2.0)) * DEFAULT_CELL_HEIGHT + ((CGFloat(10)/2.0) - 1.0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == RECOMMENDED_MEAL_INDEX || section == FAV_MEALS_INDEX) {
            if (!NetworkManager.IsLoggedIn()) {
                return 0
            }
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        if (indexPath.section == RECOMMENDED_MEAL_INDEX || indexPath.section == FAV_MEALS_INDEX) {
            let cell = MealTableViewCellWithCollectionView(style: .default, reuseIdentifier: "collectionCell", scrollDirection: .horizontal)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
            return cell
        }
        
        let cell = MealTableViewCellWithCollectionView(style: .default, reuseIdentifier: "topMealCell", scrollDirection: .vertical)
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.section
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (!NetworkManager.IsLoggedIn()) {
            if (section == RECOMMENDED_MEAL_INDEX || section == FAV_MEALS_INDEX) {
                return 0.0
            }
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
        case FAV_MEALS_INDEX:
            return NUMBER_OF_FAV_MEALS
        case RECOMMENDED_MEAL_INDEX:
            return NUMBER_OF_TOP_MEALS
        case TOP_MEALS_INDEX:
            return 10
        default:
            print("Unkwown collectionView with tag: \(collectionView.tag)")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseIdentifier : String
        switch collectionView.tag {
        case FAV_MEALS_INDEX:
            reuseIdentifier = "collectionCell"
        case RECOMMENDED_MEAL_INDEX:
            reuseIdentifier = "collectionCell"
        case TOP_MEALS_INDEX:
            reuseIdentifier = "topMealCell"
        default:
            print("Unkwown collectionView with tag: \(collectionView.tag)")
            reuseIdentifier = "collectionCell"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.meal = Meal.test_meals[indexPath.row % Meal.test_meals.count]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case FAV_MEALS_INDEX:
            NUMBER_OF_FAV_MEALS -= 1
            tableView.reloadData()
        case RECOMMENDED_MEAL_INDEX:
            NUMBER_OF_TOP_MEALS -= 1
            tableView.reloadData()
        default:
            return
        }
    }
}
