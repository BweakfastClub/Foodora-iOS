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
        tv.rowHeight = 100.0
//        tv.estimatedRowHeight = 300
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MealTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.meal = Meal("Burger", "https://cms.splendidtable.org/sites/default/files/styles/w2000/public/Burger-Lab_Lamb-Burger-LEDE.jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UITableViewHeaderFooterView(reuseIdentifier: "headerCell")
        headerCell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 16)!
        switch section {
            case 0:
                headerCell.textLabel?.text = "FAVORITES"
            case 1:
                headerCell.textLabel?.text = "TOP MEALS"
            case 2:
                headerCell.textLabel?.text = "RECOMMENDED BREAKFAST"
            case 3:
                headerCell.textLabel?.text = "RECOMMENDED LUNCH"
            case 4:
                headerCell.textLabel?.text = "RECOMMENDED DINNER"
            default:
                headerCell.textLabel?.text = "RECOMMENDED DINNER"
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
