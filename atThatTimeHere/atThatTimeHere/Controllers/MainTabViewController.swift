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
        // tab1 : 내가쓴  메모 테이블리스트 -> row에는 제목 + (날짜or주소)
        // 화면 오른쪽. 하단에. (...) 에 버튼 있어서 누르면 이용약관(이앱은. 정보를 저장하지 ㅇ ㅏㄴㅎ습니다), 스토어 별점주기
//        let profileVC = UINavigationController(rootViewController: ProfileViewController())
//        profileVC.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
//        profileVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
//        profileVC.navigationBar.tintColor = CUSTOM_PURPLE
//        
//        // tab2 : 메모쓰기
//        let bluetoothVC =  UINavigationController(rootViewController: BluetoothSearchViewController())
//        bluetoothVC.tabBarItem.image = #imageLiteral(resourceName: "search_unselected")
//        bluetoothVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "search_selected")
//        bluetoothVC.navigationBar.tintColor = CUSTOM_PURPLE
//        
//        viewControllers = [profileVC, bluetoothVC]
//        tabBar.tintColor = CUSTOM_PURPLE
    }
    
}
