//
//  LoginViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-25.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let mainStackView : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    var inputSubview : UIView = {
        return UIView()
    }()
    
    var buttonsSubView : UIView = {
        return UIView()
    }()
    
    let logoImageContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView : UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "brain")
        return view
    }()
    
    var usernameTextField : UnderlinedTextField = {
        let field = UnderlinedTextField(icon: "\u{f007}", placeholderText: "Email", placeholderColor: Style.GRAY, textColor: Style.GRAY, elementsColor: Style.GRAY, activeColor: .black)
        field.underlineColor = Style.LIGHT_GRAY
        field.autocapitalizationType = .none
        return field
    }()
    
    var passwordTextField : UnderlinedTextField = {
        let field = UnderlinedTextField(icon: "\u{f023}", placeholderText: "Password", placeholderColor: Style.GRAY, textColor: Style.GRAY, elementsColor: Style.GRAY, activeColor: .black)
        field.isSecureTextEntry = true
        field.underlineColor = Style.LIGHT_GRAY
        field.autocapitalizationType = .none
        return field
    }()
    
    var loginButton : BetterButton = {
        let button = BetterButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = Style.main_color
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.LoginButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var registerLabel : UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = UIFont(name: "PingFangHK-Ultralight", size: 20)
        label.textAlignment = .center
        label.textColor = Style.GRAY
        return label
    }()
    
    var registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(Style.GRAY, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangHK-Light", size: 20)
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0) //Removing top/bottom padding on button.
        button.addTarget(self, action: #selector(LoginViewController.RegisterButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var dismissViewButton : UIButton = {
        let button = BetterButton()
        let label = UILabel()
        button.titleLabel?.font = UIFont(name: "fontawesome", size: 30)
        button.setTitle("\u{f00d}", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(Style.main_color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(LoginViewController.dismissView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(logoImageContainerView)
        logoImageContainerView.addSubview(logoImageView)
        
        inputSubview.addSubview(usernameTextField)
        inputSubview.addSubview(passwordTextField)
        mainStackView.addArrangedSubview(inputSubview)
        
        buttonsSubView.addSubview(loginButton)
        buttonsSubView.addSubview(registerLabel)
        buttonsSubView.addSubview(registerButton)
        mainStackView.addArrangedSubview(buttonsSubView)
        
        view.addSubview(dismissViewButton)
        
        // Setup Constraint
        SetupConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func LoginButtonSelected(sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        guard username != "" else { self.loginButton.shake(); self.usernameTextField.Error(); return }
        guard password != "" else { self.loginButton.shake(); self.passwordTextField.Error(); return }
        
        NetworkManager.shared.Login(username, password) { (statusCode, sessionKey) in
            if (statusCode == 200) {
                
                NetworkManager.shared.RetrieveUserData(callback: { (statusCode) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            } else {
                // TODO: Login failed. Display msg
            }
        }
        
    }
    
    @IBAction private func RegisterButtonClicked(sender: UIButton) {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @IBAction private func dismissView(sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public func DisplayMessageModally(msg: String) {
        // Display using a modal popup
        print("\(msg)")
    }
    
    private func SetupConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dismissViewButton.widthAnchor.constraint(equalToConstant: 40),
            dismissViewButton.heightAnchor.constraint(equalToConstant: 40),
            dismissViewButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dismissViewButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10)
        ])
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: logoImageContainerView.widthAnchor, multiplier: 0.50),
            logoImageView.heightAnchor.constraint(equalTo: logoImageContainerView.heightAnchor, multiplier: 0.50),
            logoImageView.centerYAnchor.constraint(equalTo: logoImageContainerView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoImageContainerView.centerXAnchor)
        ])
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameTextField.widthAnchor.constraint(equalTo: self.inputSubview.widthAnchor, multiplier: 0.80),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40.0),
            usernameTextField.centerXAnchor.constraint(equalTo: self.inputSubview.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: self.inputSubview.centerYAnchor, constant: -25),
            passwordTextField.widthAnchor.constraint(equalTo: self.inputSubview.widthAnchor, multiplier: 0.80),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40.0),
            passwordTextField.centerXAnchor.constraint(equalTo: self.inputSubview.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: self.inputSubview.centerYAnchor, constant: 25)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: self.buttonsSubView.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: self.buttonsSubView.centerYAnchor),
            loginButton.widthAnchor.constraint(equalTo: self.buttonsSubView.widthAnchor, multiplier: 0.75),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            registerLabel.centerXAnchor.constraint(equalTo: buttonsSubView.centerXAnchor),
            registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerLabel.widthAnchor.constraint(equalTo: buttonsSubView.widthAnchor),
            registerButton.centerXAnchor.constraint(equalTo: buttonsSubView.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: registerLabel.bottomAnchor)
        ])
    }
    
}
