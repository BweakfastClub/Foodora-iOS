//
//  LoadingViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-11-11.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    let logoImage: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "brain")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(logoImage)
        
        ApplyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Hello")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.splashScreenCompleted()
        }
    }
    
    private func ApplyConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        // Logo imageView
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 125),
            logoImage.widthAnchor.constraint(equalToConstant: 125),
            logoImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
}
