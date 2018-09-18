//
//  BrowseViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class BrowseViewController : UIViewController {
    
    private var breakfastCell: BrowseOptionView!
    private var lunchCell: BrowseOptionView!
    private var dinnerCell: BrowseOptionView!
    private var snacksCell: BrowseOptionView!
    
    private let mainStack: UIStackView = {
        let view = UIStackView()
        view.spacing = 10.0
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "BROWSE"
        
        view.addSubview(mainStack)
        
        let breakfastTap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        breakfastCell = BrowseOptionView("https://images5.alphacoders.com/432/432498.jpg", "BREAKFAST")
        breakfastCell.addGestureRecognizer(breakfastTap)
        mainStack.addArrangedSubview(breakfastCell)

        let lunchTap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        lunchCell = BrowseOptionView("https://images6.alphacoders.com/609/609345.jpg", "LUNCH")
        lunchCell.addGestureRecognizer(lunchTap)
        mainStack.addArrangedSubview(lunchCell)
        
        let dinnerTap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        dinnerCell = BrowseOptionView("https://imgur.com/yQbH8Yk.png", "DINNER")
        dinnerCell.addGestureRecognizer(dinnerTap)
        mainStack.addArrangedSubview(dinnerCell)
        
        let snackTap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        snacksCell = BrowseOptionView("https://imgur.com/x7nGYB8.png", "SNACKS")
        snacksCell.addGestureRecognizer(snackTap)
        mainStack.addArrangedSubview(snacksCell)
        
        ApplyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 50)
        
        let viewNavBar = UIView(frame: CGRect(
            origin: CGPoint(x: 0, y:0),
            size: CGSize(width: self.view.frame.size.width, height: 100)))
        
        self.navigationController?.navigationBar.addSubview(viewNavBar)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func ApplyConstraints() {
        let safeMargin = view.safeAreaLayoutGuide
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeMargin.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: safeMargin.bottomAnchor, constant: -10),
            mainStack.leftAnchor.constraint(equalTo: safeMargin.leftAnchor, constant: 20),
            mainStack.rightAnchor.constraint(equalTo: safeMargin.rightAnchor, constant: -20)
        ])
    }
    
    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! BrowseOptionView
        let vc = MealSelectionViewController()
        vc.title = view.GetTitle()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

