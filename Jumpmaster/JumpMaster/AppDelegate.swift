//
//  AppDelegate.swift
//  JumpMaster
//
//  Created by Jan Dub on 20.12.2024.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Povolené orientace (pouze na šířku)
        return .landscape
    }
}
