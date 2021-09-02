//
//  MainTabViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTabbarController()
    }
    
    //MARK: methods
    private func configureTabbarController() {
        print("debug :MainTabViewController  configureTabbarController")
        // tab1 : 추억보기
        let listVC = UINavigationController(rootViewController: NoteListViewController())
        listVC.tabBarItem.image = #imageLiteral(resourceName: "unselected_heart")
        listVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "selected_heart")
        listVC.navigationBar.tintColor = CUSTOM_MAIN_COLOR
        
        // tab2 : 추억쓰기
        let menuVC =  UINavigationController(rootViewController: MenuViewController())
        menuVC.tabBarItem.image = #imageLiteral(resourceName: "unselected_menu")
        menuVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "selected_menu")
        menuVC.navigationBar.tintColor = CUSTOM_MAIN_COLOR
        
        viewControllers = [listVC, menuVC]
        tabBar.tintColor = CUSTOM_MAIN_COLOR
    }
    
}
