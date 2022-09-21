//
//  AppDelegate.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-07-29.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appRouter: AppRouter = AppRouter()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appRouter = AppRouter()

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = appRouter.navigationController
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        
        appRouter.showInitialNavigationScreen()
        // Use this code to have Tabbar layour example
        // appRouter.showInitialTabbar()
        
        return true
    }
}
