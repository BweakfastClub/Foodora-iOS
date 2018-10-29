//
//  UISearchBar+Extensions.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-10-28.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setSearchFieldBackgroundColor(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = color
    }
    
    func setPlaceholderTextColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func setMagnifyingGlassColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}
