//
//  NetworkManager.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct LoginResponse : Codable {
    var token : String
    
    init(token: String) {
        self.token = token
    }
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

class NetworkManager {
    
    static private let BASE_URL : String = "http://cpserver.eastus.cloudapp.azure.com"
    static private let BASE_PORT : String = "8080"
    
    static private let postImageCache = NSCache<NSString, UIImage>()
    
    static private let defaultSession = URLSession(configuration: .default)
    static private var defaultTask : URLSessionDataTask?
    
    static private var sessionKey : String?
    
    public static func IsLoggedIn() -> Bool {
        return sessionKey != nil
    }
    
    public static func Register(email: String, username: String, password: String, callback: @escaping (_ status: Int) -> Void) {
        guard email != "" else { return callback(400) }
        guard username != "" else { return callback(400) }
        guard password != "" else { return callback(400) }
        
        let body = [
            "email": email,
            "name": username,
            "password": password
        ]
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/users") else {
            print("Failed to create url")
            return callback(400) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(400)
        }
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to convert body dict to JSON")
            return callback(400)
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.httpBody = jsonBody
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Error registering")
                return callback(500)
            }
            
            guard let _ = data, let res = res as? HTTPURLResponse else {
                debugPrint("Failed to get data/res")
                return callback(500)
            }
            
            return callback(res.statusCode)
        }.resume()
    }
    
    public static func Login(_ username: String, _ password: String, callback: @escaping (_ statusCode: Int, _ sessionKey: String?) -> Void) {
        guard username != "" else { return callback(400, nil) }
        guard password != "" else { return callback(400, nil) }
        
        let body = [
            "email": username,
            "password": password
        ]
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/users/login") else {
            print("Failed to create url")
            return callback(400, nil) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(400, nil)
        }
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to convert body dict to JSON")
            return callback(400, nil)
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.httpBody = jsonBody
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Error loging in")
                return callback(500, nil)
            }
            
            guard let data = data, let res = res as? HTTPURLResponse else {
                debugPrint("Failed to get data/res")
                return callback(500, nil)
            }
            
            if (res.statusCode != 200) {
                return callback(res.statusCode, nil)
            }
            
            do {
                let loginRes = try JSONDecoder().decode(LoginResponse.self, from: data)
                sessionKey = loginRes.token
                callback(res.statusCode, loginRes.token)
            } catch let error {
                print(error)
                return callback(500, nil)
            }
        }.resume()
    }
    
    public static func Search(_ query: String, callback: @escaping (_ meals: [Meal]?) -> Void) {

        let searchBody = ["$search": query]
        let textBody = ["$text": searchBody]
        let body = ["query": textBody]
        
        print(body)
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/recipes/search") else {
            print("Failed to create url")
            return callback(nil) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(nil)
        }
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to convert body dict to JSON")
            return callback(nil)
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.httpBody = jsonBody
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Error searching")
                return callback(nil)
            }
            
            guard let data = data, let res = res as? HTTPURLResponse else {
                debugPrint("Failed to get data/res")
                return callback(nil)
            }
            
            if (res.statusCode != 200) {
                debugPrint("Search status code: \(res.statusCode)")
                return callback(nil)
            }
            
            do {
                let meals = try JSONDecoder().decode([Meal].self, from: data)
                callback(meals)
            } catch let error {
                print(error)
                return callback(nil)
            }
        }.resume()
    }
    
    public static func TopRecipes(callback: @escaping (_ meals: [Meal]?) -> Void) {
        
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/recipes/top_recipes") else {
            print("Failed to create url")
            return callback(nil) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(nil)
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Error searching")
                return callback(nil)
            }
            
            guard let data = data, let res = res as? HTTPURLResponse else {
                debugPrint("Failed to get data/res")
                return callback(nil)
            }
            
            if (res.statusCode != 200) {
                debugPrint("Search status code: \(res.statusCode)")
                return callback(nil)
            }
            
            do {
                let meals = try JSONDecoder().decode([Meal].self, from: data)
                callback(meals)
            } catch let error {
                print(error)
                return callback(nil)
            }
            }.resume()
    }
    
    public static func GetImageByUrl(_ imageURLString : String, callback: @escaping (_ image: UIImage?) -> Void) {
        if let image = postImageCache.object(forKey: imageURLString as NSString) {
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
