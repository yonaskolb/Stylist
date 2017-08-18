//
//  AppDelegate.swift
//  Example
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import UIKit
import Stylist

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        do {
            let theme = try Theme(path: Bundle.main.path(forResource: "Style", ofType: "yaml")!)
            Stylist.shared.apply(theme: theme)
        }catch {
            print("Error loading theme:\n\(error)")
        }
        return true
    }

}

