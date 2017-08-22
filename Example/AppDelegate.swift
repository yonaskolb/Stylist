//
//  AppDelegate.swift
//  Example
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import UIKit
import Stylist
import KZFileWatchers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var fileWatcher: FileWatcherProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let path =  (#file as NSString).deletingLastPathComponent + "/Style.yaml"
        let url = URL(fileURLWithPath: path)
        Stylist.shared.watch(url: url, animateChanges: true) { error in
            print("Error loading theme:\n\(error)")
        }

        return true
    }
    
}

