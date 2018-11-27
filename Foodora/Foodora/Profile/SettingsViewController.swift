//
//  SettingsViewController.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-11-13.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Settings View", attributes: [
            NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 34)!,
            NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        label.textAlignment = .center
        return label
    }()
    
    var logoutButton: BetterButton = {
        let button = BetterButton()
        button.setTitle("LOGOUT", for: .normal)
        button.backgroundColor = Style.main_color
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(SettingsViewController.logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SETTINGS"
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableSelectionCell.self, forCellReuseIdentifier: "selectionCell")
        view.addSubview(tableView)
        
        view.addSubview(logoutButton)
        
        ApplyConstraints()
    }
    
    @IBAction private func logoutButtonPressed(sender: UIButton) {
        NetworkManager.shared.Logout()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func ApplyConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -5)
        ])
        
        // Title label constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! UITableSelectionCell
        cell.desc = "Cell \(indexPath.section) \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = MealSectionTableViewHeader(reuseIdentifier: "headerCell")
        headerCell.text = "SECTION \(section)"
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}




// SELECTION CELL
class UITableSelectionCell: UITableViewCell {
    
    public var desc: String = "" {
        didSet {
            descLabel.text = desc
        }
    }
    
    private let descLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)!
        label.textColor = Style.GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggle: UISwitch = {
        let toggle = UISwitch(frame: .zero)
        toggle.isOn = true
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descLabel)
        addSubview(toggle)
        
        ApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ApplyConstraints() {
        
        NSLayoutConstraint.activate([
            
            toggle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            toggle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            descLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            descLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
            
        ])
        
    }
    
}
