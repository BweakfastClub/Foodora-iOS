//
//  MealCollectionViewCell.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    
    private var meal: Meal? {
        didSet {
            UpdateCell()
        }
    }
    
    private let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "placeholder")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImage)
        
        ApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func UpdateCell() {
        
    }
    
    private func ApplyConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5)
        ])
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
}
