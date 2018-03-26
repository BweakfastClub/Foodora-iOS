//
//  MealViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-25.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class MealViewController : UIViewController {
    
    var gradient = CAGradientLayer()
    
    private var meal: Meal? {
        didSet {
            UpdateView()
        }
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    convenience init(meal: Meal) {
        self.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        self.meal = meal
        
        view.addSubview(imageView)
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.50, 1]
        imageView.layer.mask = gradient
        
        UpdateView()
        ApplyConstraints()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        gradient.frame = imageView.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func UpdateView() {
        if meal != nil {
            NetworkManager.GetImageByUrl(meal!.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func ApplyConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
    }
    
}
