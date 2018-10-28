//
//  AppDelegate.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-03-04.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        // root tab controller init
        let rootTabController = UITabBarController()
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.viewControllers = [HomeViewController()]

        let searchNavigationController = UINavigationController()
        searchNavigationController.viewControllers = [SearchViewController()]

        let mealPlanNavigationController = UINavigationController()
        mealPlanNavigationController.viewControllers = [MealPlanViewController()]

        let profileNavigationController = UINavigationController()
        profileNavigationController.viewControllers = [LoginViewController()]

        rootTabController.viewControllers = [
            homeNavigationController,
//            browseNavigationController,
            searchNavigationController,
            mealPlanNavigationController
//            profileNavigationController
        ]

        let tabBarItems = rootTabController.tabBar.items! as [UITabBarItem]
        rootTabController.tabBar.tintColor = Style.main_color
//        tabBarItems[0].title = "Home"
        tabBarItems[0].image = UIImage(named: "restaurant")
        tabBarItems[0].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
//        tabBarItems[1].title = "Browse"
//        tabBarItems[1].image = #imageLiteral(resourceName: "coffee")
//        tabBarItems[1].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
//        tabBarItems[2].title = "Search"
        tabBarItems[1].image = UIImage(named: "search")
        tabBarItems[1].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
//        tabBarItems[3].title = "Plan"
        tabBarItems[2].image = UIImage(named: "book")
        tabBarItems[2].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
//        tabBarItems[4].title = "Profile"
//        tabBarItems[4].image = #imageLiteral(resourceName: "user")
//        tabBarItems[4].imageInsets = UIEdgeInsetsMake(6,0,-6,0)

        window?.rootViewController = rootTabController
        window?.makeKeyAndVisible()

        // Remove the name of previous view from navigation bar next to back button
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)

        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = Style.GRAY
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 20)!,
            NSAttributedStringKey.foregroundColor: Style.GRAY
        ]
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Next", size: 20)!]
        
        //remove black bar under nav bar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
