//
//  CustomTabBarViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 13.11.23.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureTabBar()
    }
    
    func setupTabBar() {
            
        let mainViewController = setupVC(viewController: ListGamesViewController(), title: "games_list".localize(), image: setupImage(named: "gamecontroller"))
        let createViewController = setupVC(viewController: RulesViewController(), title: "game_rules".localize(), image: setupImage(named: "book"))
        let nocreateViewController = setupVC(viewController: WhiteboardViewController(), title: "games_history".localize(), image: setupImage(named: "clock.arrow.circlepath"))
        let profileViewController = setupVC(viewController: SettingsViewController(), title: "settings".localize(), image: setupImage(named: "gearshape"))
        let createViewControllerS = setupVC(viewController: ProfileViewController(), title: "profile".localize(), image: setupImage(named: "person"))
            
            // Ограничиваем количество отображаемых контроллеров в таб-баре
            let visibleViewControllers = [mainViewController, createViewController, nocreateViewController, profileViewController, createViewControllerS]
            viewControllers = visibleViewControllers
        }
    
    func setupImage(named: String) -> UIImage? {
//        if let image = UIImage(systemName: named) {
//            return UIImage(cgImage: (image.cgImage!), scale: 12, orientation: image.imageOrientation)
//
//        } else {
//            return nil
//        }
        
        if let image = UIImage(systemName: named) {
            return image
        } else {
            return nil
        }
    }
    
    private func setupVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let font = UIFont.sfProText(ofSize: 10, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        viewController.tabBarItem.title = title
        viewController.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        viewController.tabBarItem.image = image
        return viewController
    }
    
    func configureTabBar() {
        tabBar.tintColor = UIColor(hex: 0x8965C3, alpha: 1)
        tabBar.backgroundColor = UIColor(named: "viewColor")
    }
    }
