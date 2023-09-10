//
//  NSTabBarController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit

final class NSTabBarController: UITabBarController {

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
        firstVC.title = "쇼핑"
        firstVC.tabBarItem.title = "검색"
        firstVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let secondVC = NSLikedViewController()
        let secondNav = UINavigationController(rootViewController: secondVC)
        secondVC.title = "좋아요 목록"
        secondVC.tabBarItem.title = "좋아요"
        secondVC.tabBarItem.image = UIImage(systemName: "heart")
        
//        let thirdVC = NSMoreViewController()
//        let thirdNav = UINavigationController(rootViewController: thirdVC)
//        thirdVC.tabBarItem.title = "더보기"
//        thirdVC.tabBarItem.image = UIImage(systemName: "ellipsis")
        
        setViewControllers([firstNav, secondNav], animated: true)
    }
    
    private func setupTabBarController() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
    }
    
    private func configureTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowRadius = 10
    }

}
