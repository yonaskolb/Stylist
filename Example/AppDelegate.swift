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

        let path =  #file.replacingOccurrences(of: "AppDelegate.swift", with: "Style.yaml")
        fileWatcher = FileWatcher.Local(path: path)
        do {
            try fileWatcher?.start() { result in
                switch result {
                case .noChanges:
                    break
                case .updated(let data):
                    do {
                        let theme = try Theme(data: data)
                        UIView.animate(withDuration: 0.2) {
                            Stylist.shared.apply(theme: theme)
                        }
                    } catch {
                        print("Error loading theme:\n\(error)")
                    }
                }
            }
        } catch {
            print("Error watching file:\n\(error)")
        }

        return true
    }
    
}

