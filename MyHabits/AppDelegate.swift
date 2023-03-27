//
//  AppDelegate.swift
//  TestOne
//
//  Created by Alexander on 15.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        return true
        
    }
}

func createHabitsViewController() -> UINavigationController {
    let habitsViewController = HabitsViewController()
    habitsViewController.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(systemName: "rectangle.grid.1x2.fill"), tag: 1)
    habitsViewController.title = "Сегодня"
    
    return UINavigationController(rootViewController: habitsViewController)
}

func createInfoViewController() -> UINavigationController {
    let infoViewController = InfoViewController()
    infoViewController.title = "Информация"
    infoViewController.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 0)
    return UINavigationController(rootViewController: infoViewController)
}

func createTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    UITabBar.appearance().tintColor = .purple
    tabBarController.viewControllers = [createHabitsViewController(), createInfoViewController()]
    return tabBarController
}
