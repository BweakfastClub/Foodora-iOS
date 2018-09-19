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
    
    public var cellHeight : CGFloat = 130.0
    
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
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let filter : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 0.46)
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
        let padding : CGFloat = 1.0
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
        
        NSLayoutConstraint.activate([
            filter.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            filter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding),
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
