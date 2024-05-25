//
//  MainTabbarController.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 18.05.2024.
//

import UIKit

final class MainTabbarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    private func setupTabbar() {
        tabBar.backgroundColor = .systemGray3
        
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeViewController.viewModel = homeViewModel
        
        let favoritesViewController = FavoritesViewController()
        
        
        let vcFirst = UINavigationController(rootViewController: homeViewController)
        let vcSecond = UINavigationController(rootViewController: favoritesViewController)
        
        vcFirst.tabBarItem.image = UIImage(systemName: "gamecontroller")
        vcSecond.tabBarItem.image = UIImage(systemName: "heart")
        vcFirst.tabBarItem.title = "Games"
        vcSecond.tabBarItem.title = "Favorites"

        tabBar.tintColor = .label
        setViewControllers([vcFirst, vcSecond], animated: true)
    }
}

