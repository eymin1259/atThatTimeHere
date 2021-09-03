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
        
        // 알람 클릭시 발송되는 noti 인식 -> selected index = noteListViewController로 설정
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePushAlarm), name: NSNotification.Name(rawValue: DID_RECEIVE_PUSH_ALARM), object: nil)
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
    
    //MARK: actions
    @objc func didReceivePushAlarm(noti : Notification){
        // selected index = noteListViewController로 설정
        self.selectedIndex = 0
    }
}
