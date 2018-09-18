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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Home View", attributes: [
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 34)!,
            NSAttributedStringKey.foregroundColor: UIColor(red:0.21, green:0.23, blue:0.28, alpha:1.0)
        ])
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "HOME"
        
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "circle-user"), style: .plain, target: self, action: #selector(self.someFunc))
        leftButton.tintColor = Style.main_color
        self.navigationItem.leftBarButtonItem = leftButton
        
        view.addSubview(titleLabel)
        ApplyConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func someFunc() {
        
        print("It Works")
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // Title label constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
