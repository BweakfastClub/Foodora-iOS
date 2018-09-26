//
//  MealTableViewCell+CollectionViewTableViewCell.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-09-19.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import UIKit

class MealTableViewCellWithCollectionView: UITableViewCell {

    private var scrollDirection : UICollectionViewScrollDirection = .vertical
    
    let spacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView : UICollectionView = {
        var layout : UICollectionViewLayout
        layout = HorizontalCollectionViewLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.LIGHT_WHITE
//        view.isScrollEnabled = false
        return view
    }()

    public convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, scrollDirection _scrollDirection: UICollectionViewScrollDirection) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        self.scrollDirection = _scrollDirection
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        addSubview(spacerView)
        spacerView.addSubview(collectionView)
        
        ApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func ApplyConstraints() {
        NSLayoutConstraint.activate([
            spacerView.topAnchor.constraint(equalTo: topAnchor),
            spacerView.rightAnchor.constraint(equalTo: rightAnchor),
            spacerView.leftAnchor.constraint(equalTo: leftAnchor),
            spacerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: spacerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: spacerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: spacerView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: spacerView.rightAnchor)
        ])
    }
    
}
