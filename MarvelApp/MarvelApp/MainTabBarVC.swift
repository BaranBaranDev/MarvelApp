//
//  MainTabBarVC.swift
//  MarvelApp
//
//  Created by Baran Baran on 30.05.2024.
//

import UIKit

final class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Helpers

extension MainTabBarVC {
    
    // Tab bar'ı oluşturma ve özelleştirme fonksiyonu
    private func setup() {
        // Tab bar'a eklenecek view controller'ları oluştur
        let characterVC = createViewController(rootVC: CharacterBuilder.build(), title: "Character", image: "house.fill")
        let favoriteVC = createViewController(rootVC: FavoritesBuilder.build(), title: "Favorite", image: "star.fill")

        
        // Oluşturulan view controller'ları tab bar'a ekle
        viewControllers = [characterVC, favoriteVC]
        
        // Tab bar'ı ve navigation bar'ı özelleştir
        customizeTabBar()
        customizeNavigationBar()
    }
    
    // Her view controller için UINavigationController oluşturma fonksiyonu
    private func createViewController(rootVC: UIViewController, title: String, image: String) -> UIViewController {
        let controller = UINavigationController(rootViewController: rootVC)
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(systemName: image)
        
        // View controller başlığını ayarlama
        rootVC.title = title
        
        return controller
    }
    
    // Tab bar'ı özelleştirme fonksiyonu
    private func customizeTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    // Navigation bar'ı özelleştirme fonksiyonu
    private func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
    }
}
