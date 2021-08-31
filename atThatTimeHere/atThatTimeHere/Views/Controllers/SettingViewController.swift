//
//  SettingViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import StoreKit

class SettingViewController: BaseViewController {

    //MARK: UI
    private var  myinfoLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("내 정보", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapMyInfo), for: .touchUpInside)
        return btn
    }()
    
    private var  appVersionLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("앱 정보", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapAppVersion), for: .touchUpInside)
        return btn
    }()
    
    private var TermsLbl :  UIButton  =  {
        // 정보저장x, 앱버전
        let btn = UIButton(type: .system)
        btn.setTitle("이용약관", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapTermsOfService), for: .touchUpInside)
        return btn
    }()
    
    private var privacyLbl :  UIButton  =  {
        // 정보저장x, 앱버전
        let btn = UIButton(type: .system)
        btn.setTitle("개인정보 처리방침", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        return btn
    }()
    
    private var  appReviewLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("별점과 리뷰", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapAppReview), for: .touchUpInside)
        return btn
    }()
    
    private var  logoutLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("로그아웃", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return btn
    }()


    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: methods
    func setupUI(){

        let stackView = UIStackView(arrangedSubviews: [ myinfoLbl, appVersionLbl, TermsLbl, privacyLbl, appReviewLbl, logoutLbl])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    //MARK: actions
    @objc func didTapMyInfo(){
        // id
        print("debug : didTapMyInfo  ")
        showDialog(title: "내 정보", message: "ㅁ")
    }
    
    @objc func didTapAppVersion(){
        guard let dictionary = Bundle.main.infoDictionary else {return}
        guard let version = dictionary["CFBundleShortVersionString"] as? String else {return}
        
        showDialog(title: "앱 정보", message: "\nvserion : \(version)\nemail : eymin1259@gmail.com")
    }
    
    @objc func didTapTermsOfService(){
        // 정보저장x, 앱버전
        print("debug : didTapTermsOfService  ")
        showDialog(title: "이용약관", message: "ㅠ")
    }
    
    @objc func didTapPrivacy(){
        // 개인정보처리방침
        print("debug : didTapTermsOfService  ")
        showDialog(title: "개인정보 처리방침", message: "ㅊ")
    }
    
    @objc func didTapAppReview(){
        // storekit
        // https://zeddios.tistory.com/551
        print("debug : didTapAppReview  ")
    }
    
    @objc func didTapLogout(){
        // 유저정보 삭제
        UserService.shared.logout()
        
        // 인트로VC로 이동
        DispatchQueue.main.async {
            let controller = IntroViewController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
    }
}
