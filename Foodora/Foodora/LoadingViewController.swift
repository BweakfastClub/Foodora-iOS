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
    
    let statusLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "AvenirNext-Bold", size: 16)!
        l.textColor = Style.GRAY
        l.textAlignment = .center
        l.alpha = 1.0
        l.text = "Connecting to Server..."
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(logoImage)
        view.addSubview(statusLabel)
        
        ApplyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.Ping { (statusCode) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                if (statusCode == 200) {
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.splashScreenCompleted()
                } else {
                    self.statusLabel.text = "Failed to connect to server."
                }
            }
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
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 10),
            statusLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -5)
        ])
    }
    
}
