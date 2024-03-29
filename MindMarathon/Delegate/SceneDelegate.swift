//
//  SceneDelegate.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        let homeVC = CustomTabBarController()
//        let navigationController = UINavigationController(rootViewController: homeVC)
        self.window?.rootViewController = homeVC
        self.window?.makeKeyAndVisible()
        
        let currentTheme = UserDefaultsManager.shared.getTheme()
        let currentLang = UserDefaultsManager.shared.getLanguage()
        switch currentTheme {
        case "dark":
            window?.overrideUserInterfaceStyle = .dark
        case "light":
            window?.overrideUserInterfaceStyle = .light
        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
}
