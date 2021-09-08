//
//  ViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

class IntroViewController: UIViewController {
    
    // MARK: UI
    
    private let atThatTimeLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "그때"
        text.textColor = .white
        text.font = UIFont(name: CUSTOM_FONT, size: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let hereLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "이곳"
        text.textColor = .white
        text.font = UIFont(name: CUSTOM_FONT, size: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let dotLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "。"
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
        
        // 초기 db 세팅 -> make apple test account
        AuthService.shared.creatAppleTestAccount()
        
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
        
        view.addSubview(atThatTimeLbl)
        atThatTimeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        atThatTimeLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -18).isActive = true
        
        view.addSubview(hereLbl)
        hereLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hereLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 18).isActive = true
        
        view.addSubview(dotLbl)
        dotLbl.leadingAnchor.constraint(equalTo: hereLbl.trailingAnchor).isActive = true
        dotLbl.bottomAnchor.constraint(equalTo: hereLbl.bottomAnchor).isActive = true
    }
}

