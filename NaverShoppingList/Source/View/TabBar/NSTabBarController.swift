//
//  NSTabBarController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit

final class NSTabBarController: UITabBarController {
    typealias CT = Constants
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        configureTabBarController()
        setupTabBarController()
        configureTabBarShadow()
    }
    
    private func configureTabBarController() {
        let firstVC = NSSearchViewController()
        let firstNav = UINavigationController(rootViewController: firstVC)
        firstVC.title = "searchVC_title".localized
        firstVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let secondVC = NSLikedViewController()
        let secondNav = UINavigationController(rootViewController: secondVC)
        secondVC.title = "likedVC_title".localized
        secondVC.tabBarItem.image = UIImage(systemName: "heart")
        
        setViewControllers([firstNav, secondNav], animated: true)
    }
    
    private func setupTabBarController() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
    }
    
    private func configureTabBarShadow() {
        tabBar.layer.shadowColor = CT.tabBarShadowColor
        tabBar.layer.shadowOffset = CT.tabBarShadowOffset
        tabBar.layer.shadowOpacity = CT.tabBarShadowOpacity
        tabBar.layer.shadowRadius = CT.tabBarShadowRadius
    }

}
