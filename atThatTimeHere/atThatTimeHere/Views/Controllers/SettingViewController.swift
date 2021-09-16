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
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapMyInfo), for: .touchUpInside)
        return btn
    }()
    
    private var  appVersionLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("앱 정보", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapAppVersion), for: .touchUpInside)
        return btn
    }()
    
    private var TermsLbl :  UIButton  =  {
        // 정보저장x, 앱버전
        let btn = UIButton(type: .system)
        btn.setTitle("이용약관", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapTermsOfService), for: .touchUpInside)
        return btn
    }()
    
    private var privacyLbl :  UIButton  =  {
        // 정보저장x, 앱버전
        let btn = UIButton(type: .system)
        btn.setTitle("개인정보 처리방침", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        return btn
    }()
    
    private var  appReviewLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("의견 보내기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapAppReview), for: .touchUpInside)
        return btn
    }()
    
    private var  logoutLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("로그아웃", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
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

        // 스택뷰 생성 -> myinfoLbl, appVersionLbl, TermsLbl, privacyLbl, appReviewLbl, logoutLbl 포함
        
        // 이용약관, 개인정보처리방침 포함
        // let stackView = UIStackView(arrangedSubviews: [ myinfoLbl, appVersionLbl, TermsLbl, privacyLbl, appReviewLbl, logoutLbl])
        
        // 이용약관, 미포함
        let stackView = UIStackView(arrangedSubviews: [ myinfoLbl, appVersionLbl, privacyLbl, appReviewLbl, logoutLbl])
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
        guard let email = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["email"] else { return }
        showDialog(title: "내 정보", message: "email : \(email)")
    }
    
    @objc func didTapAppVersion(){
        guard let dictionary = Bundle.main.infoDictionary else {return}
        guard let version = dictionary["CFBundleShortVersionString"] as? String else {return}
        
        showDialog(title: "앱 정보", message: "\nvserion : \(version)\n개발자 : eymin1259@gmail.com")
    }
    
    @objc func didTapTermsOfService(){
        // 정보저장x, 앱버전
        print("debug : didTapTermsOfService  ")
        showDialog(title: "이용약관", message: TERMS_OF_SERVICE)
    }
    
    @objc func didTapPrivacy(){
        // 개인정보처리방침
        print("debug : didTapTermsOfService  ")
        showDialog(title: "개인정보 처리방침", message: PRIVACY_POLICY)
    }
    
    @objc func didTapAppReview(){
        // 의견 보내기
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @objc func didTapLogout(){
        // 유저정보 삭제
        AuthService.shared.logout()
        
        // 인트로VC로 이동
        DispatchQueue.main.async {
            let controller = IntroViewController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
    }
}
