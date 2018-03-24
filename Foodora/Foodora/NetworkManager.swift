//
//  NetworkManager.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit.UIImage

class NetworkManager {
    
    private let postImageCache = NSCache<NSString, UIImage>()
    
    private let defaultSession = URLSession(configuration: .default)
    
    public func GetImageByUrl(_ imageURLString : String, callback: @escaping (_ image: UIImage?) -> Void) {
        if let image = postImageCache.object(forKey: imageURLString as NSString) {
            print("Found \(imageURLString) in cache!")
            return callback(image)
        } else if let imageURL = URL(string: imageURLString) {
            URLSession(configuration: .default).dataTask(with: imageURL, completionHandler: { (data, res, err) in
                if err != nil {
                    print(err!)
                    return
                }
                let postImage = UIImage(data: data!)
                self.postImageCache.setObject(postImage!, forKey: imageURLString as NSString)
                return callback(postImage)
            }).resume()
        }
    }
    
}
