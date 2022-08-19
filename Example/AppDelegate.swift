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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Style.yaml")
        let commonURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("common.yml")
        Stylist.shared.localMergeWatch(urls: [url, commonURL], animateChanges: true) { error in
            print("Error loading theme:\n\(error)")
        }

        return true
    }
    
}

