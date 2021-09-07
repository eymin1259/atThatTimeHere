//
//  ViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

class IntroViewController: UIViewController {
    
    // MARK: UI
    
    private let memoryLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "추억"
        text.textColor = .white
        text.font = UIFont(name: CUSTOM_FONT, size: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let noteLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "알람"
        text.textColor = .white
        text.font = UIFont(name: CUSTOM_FONT, size: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // intro ui
        setupUI()
        
        // apple test account
        UserService.shared.creatAppleTestAccount()
        
        // 로그인여부 체크
        if let _ = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY) {
            // 로그인되어 있으면
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                let controller = MainTabViewController()
                controller.modalPresentationStyle  = .fullScreen
                self.present(controller, animated: false, completion: nil)
            }
        }else{
            // 로그인되어 있지 않으면 go login
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let controller = LoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: methods
    private func setupUI() {
        view.backgroundColor = CUSTOM_MAIN_COLOR
        
        view.addSubview(memoryLbl)
        memoryLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -18).isActive = true
        
        view.addSubview(noteLbl)
        noteLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 18).isActive = true
        
    }    
}

