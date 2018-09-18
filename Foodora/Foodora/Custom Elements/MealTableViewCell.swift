//
//  MealTableViewCell.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-09-18.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealTableViewCell : UITableViewCell {
    
    public var meal: Meal? {
        didSet {
            UpdateCell()
        }
    }
    
    let mealLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)!
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let backgroundImageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let filter : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        return view
    }()
    
    private func UpdateCell() {
        if let meal = meal {
            mealLabel.text = meal.title.uppercased()
            NetworkManager.GetImageByUrl(meal.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.backgroundImageView.image = image
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        selectionStyle = .none
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        addSubview(filter)
        addSubview(mealLabel)
        ApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ApplyConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filter.topAnchor.constraint(equalTo: topAnchor),
            filter.bottomAnchor.constraint(equalTo: bottomAnchor),
            filter.rightAnchor.constraint(equalTo: rightAnchor),
            filter.leftAnchor.constraint(equalTo: leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mealLabel.leftAnchor.constraint(equalTo: leftAnchor),
            mealLabel.rightAnchor.constraint(equalTo: rightAnchor),
            mealLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
