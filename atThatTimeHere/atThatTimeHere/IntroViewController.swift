//
//  ViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit
import CoreLocation

class IntroViewController: UIViewController {
    
    // MARK: properties
    private var locationManager = CLLocationManager()
     
    // MARK: UI
    private let lbl : UILabel = {
        let text = UILabel()
        text.text = "intro"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 위치권한
        locationManager.requestAlwaysAuthorization()
        
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
        view.addSubview(lbl)
        lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

