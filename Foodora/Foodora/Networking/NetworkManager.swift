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
    
    static let shared : NetworkManager = NetworkManager(serverURL: "http://104.248.7.15")
    
    private var BASE_URL : String
    private let BASE_PORT : String
    
    private let postImageCache = NSCache<NSString, UIImage>()
    
    private let defaultSession = URLSession(configuration: .default)
    private var defaultTask : URLSessionDataTask?
    
    private var sessionKey : String?
    public var user : User?
    
    private init(serverURL: String, port: String = "8080") {
        self.BASE_URL = serverURL
        self.BASE_PORT = port
        
        self.sessionKey = getSessionKey()
        print("SessionKey: \(self.sessionKey ?? "")")
    }
    
    public func saveSessionKey() {
        UserDefaults.standard.set(self.sessionKey, forKey: "sessionKey")
    }
    
    public func getSessionKey() -> String? {
        return UserDefaults.standard.string(forKey: "sessionKey")
    }
    
    public func IsLoggedIn() -> Bool {
        return sessionKey != nil
    }
    
    public func Ping(callback: @escaping (_ status: Int) -> Void) {
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/ping") else {
            print("Failed to create url")
            return callback(400) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(400)
        }
        
        defaultSession.dataTask(with: URLRequest(url: url)) { (data, res, err) in
            if err != nil {
                debugPrint("Failed to ping server")
                return callback(500)
            }
            
            guard let _ = data, let res = res as? HTTPURLResponse else {
                debugPrint("Failed to ping server")
                return callback(500)
            }
            
            return callback(res.statusCode)
        }.resume()
    }
    
    public func RetrieveUserData(callback: @escaping (_ status: Int) -> Void) {
        print("Retrieving user data")
        if (!self.IsLoggedIn()) {
            return
        }
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/users/user_info") else {
            print("Failed to create url")
            self.sessionKey = nil
            return callback(500) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            self.sessionKey = nil
            return callback(500)
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue(self.sessionKey!, forHTTPHeaderField: "token")
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Failed to get user data")
                self.sessionKey = nil
                return callback(500)
            }
            
            guard let data = data, let res = res as? HTTPURLResponse else {
                debugPrint("Failed to get user data")
                self.sessionKey = nil
                return callback(500)
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user
                print("Retrieved user data")
                return callback(res.statusCode)
            } catch let error {
                print(error)
                self.sessionKey = nil
                return callback(500)
            }
        }.resume()
    }
    
    public func Register(email: String, username: String, password: String, callback: @escaping (_ status: Int) -> Void) {
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
    
    public func Login(_ username: String, _ password: String, callback: @escaping (_ statusCode: Int, _ sessionKey: String?) -> Void) {
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
                self.sessionKey = loginRes.token
                callback(res.statusCode, loginRes.token)
            } catch let error {
                print(error)
                return callback(500, nil)
            }
        }.resume()
    }
    
    public func Search(_ query: String, callback: @escaping (_ meals: [Meal]?) -> Void) {

        let searchBody = ["$search": query]
        let textBody = ["$text": searchBody]
        let body = ["query": textBody]
        
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
    
    public func TopRecipes(callback: @escaping (_ meals: [Meal]?) -> Void) {
        
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
    
    public func LikeMeals(_ mealIds: [Int], _ postRequest: Bool, callback: @escaping (_ success: Bool) -> Void) {
        if (!IsLoggedIn()) {
            print("Can't like recipe when not logged in.")
            return callback(false)
        }
        
        let body = [
            "recipeIds": mealIds
        ]
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/users/liked_recipes") else {
            print("Failed to create url")
            return callback(false) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(false)
        }
        
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to convert body dict to JSON")
            return callback(false)
        }
        
        var urlReq = URLRequest(url: url)
        
        if (postRequest) {
            urlReq.httpMethod = "POST"
        } else {
            urlReq.httpMethod = "DELETE"
        }
        
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue(self.sessionKey!, forHTTPHeaderField: "token")
        urlReq.httpBody = jsonBody
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Error searching")
                return callback(false)
            }
            
            guard let res = res as? HTTPURLResponse else {
                debugPrint("Failed to get data/res")
                return callback(false)
            }
            
            if (res.statusCode == 200) {
                return callback(true)
            }
            
            return callback(false)
        }.resume()
        
    }
    
    public func GetRecipeById(_ recipeId: Int, callback: @escaping (_ meal: Meal?) -> Void) {
        
        guard let urlComponent = URLComponents(string: "\(BASE_URL):\(BASE_PORT)/recipes/id/\(recipeId)") else {
            print("Failed to create url")
            return callback(nil) //TODO: handle a failure in a better way
        }
        
        guard let url = urlComponent.url else {
            print("Failed to get url")
            return callback(nil)
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        urlReq.addValue(self.sessionKey ?? "", forHTTPHeaderField: "token")
        
        defaultSession.dataTask(with: urlReq) { (data, res, err) in
            if err != nil {
                debugPrint("Error looking up recipe with id \(recipeId)")
                return callback(nil)
            }
            
            guard let data = data, let _ = res as? HTTPURLResponse else {
                debugPrint("Failed to get data/res")
                return callback(nil)
            }
            
            do {
                let meal = try JSONDecoder().decode(Meal.self, from: data)
                callback(meal)
            } catch let error {
                print(error)
                return callback(nil)
            }
        }.resume()
    }
    
    public func GetImageByUrl(_ imageURLString : String, callback: @escaping (_ image: UIImage?) -> Void) {
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
