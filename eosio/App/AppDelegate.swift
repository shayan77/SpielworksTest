//
//  AppDelegate.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // I Used Coordinator pattern for flow of app.
        setupCoordinator()
        
        return true
    }

    fileprivate func setupCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()

        appCoordinator = AppCoordinator(navigationController: navController, window: window)
        appCoordinator.start()
    }
}

