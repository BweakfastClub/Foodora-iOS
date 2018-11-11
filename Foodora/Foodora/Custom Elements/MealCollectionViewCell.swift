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
    
    public var meal: Meal? {
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
    
    private let dimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        return view
    }()
    
    private let containerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext", size: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImage)
        containerView.addSubview(dimmerView)
        containerView.addSubview(containerLabel)
        
        ApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func UpdateCell() {
        if meal != nil {
            containerLabel.text = meal!.title
            NetworkManager.shared.GetImageByUrl(meal!.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.backgroundImage.image = image
                }
            }
        }
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
        
        dimmerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        containerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
}
