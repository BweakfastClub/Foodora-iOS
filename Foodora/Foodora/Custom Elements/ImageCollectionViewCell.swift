//
//  ImageCollectionViewCell.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-09-19.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var meal : Meal? {
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
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private let imageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let filter : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 0.46)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(filter)
        addSubview(mealLabel)
        
        ApplyConstraints()
    }
    
    private func UpdateCell() {
        if let meal = meal {
            mealLabel.text = meal.title
            NetworkManager.GetImageByUrl(meal.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ApplyConstraints(){
        let padding : CGFloat = 0.0
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
