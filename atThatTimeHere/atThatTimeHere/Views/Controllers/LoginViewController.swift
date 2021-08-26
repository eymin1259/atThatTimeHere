//
//  LoginViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

class LoginViewController: BaseViewController {
    
    //MARK: properties
    var loginViewModel : AuthViewModel = {
        var vm = AuthViewModel()
        vm.isRegisterAuth = false
        return vm
    }()
    
    // MARK: UI
    private let loginTitleLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "로그인"
        text.textColor = CUSTOM_SKYBLUE.withAlphaComponent(0.8)
        text.font = UIFont(name: CUSTOM_FONT, size: 30)
        return text
    }()
    private let emailTextField : UITextField = {
        let tf = TextFieldWithPlaceholder(placeholder: "ID")
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let passwordTextField : UITextField = {
        let tf = TextFieldWithPlaceholder(placeholder: "password")
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.textContentType = .oneTimeCode
        return tf
    }()

    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("확인", for: .normal)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.9), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = CUSTOM_SKYBLUE
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addTarget(self, action: #selector(handleLoginbtn), for: .touchUpInside)
        return btn
    }()
    
    private let signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("회원이 아니시면 회원가입하러 가기!", for: .normal)
        btn.setTitleColor(CUSTOM_SKYBLUE.withAlphaComponent(0.9), for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 16)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addTarget(self, action: #selector(handlepSignupBtn), for: .touchUpInside)
        return btn
    }()
    
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ui 세팅
        setupUI()
        
        // 아이디, 패스워드 입력값 변화에 호출되는 action 함수 등록
        configureNotificationObserver()
    }
    
    // MARK: methods
    private func setupUI(){
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        // 제목
        view.addSubview(loginTitleLbl)
        loginTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        loginTitleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        loginTitleLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -230).isActive = true
        
        // 이메일, 패스워드 인풋
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 1
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: loginTitleLbl.bottomAnchor, constant: 30).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        // 로그인버튼
        view.addSubview(loginBtn)
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        loginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        loginBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        // 회원가입 버튼
        view.addSubview(signupBtn)
        signupBtn.translatesAutoresizingMaskIntoConstraints = false
        signupBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20).isActive = true
        signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // 화면터치시 키보드 내리기
        view.endEditing(true)
    }
    
    private func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: actions
    
    // 로그인버튼 클릭시
    @objc func handleLoginbtn(){
        view.endEditing(true)
        loginViewModel.login() { (loginRes, loginMsg) in
            self.view.makeToast(loginMsg)
            if loginRes {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let controller = MainTabViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    // 회원가입 버튼 클릭시
    @objc func handlepSignupBtn(){
        let controller = RegisterViewController()
        controller.modalPresentationStyle = .pageSheet
        controller.delegate =  self
        present(controller, animated: true, completion: nil)
    }
    
    // 인풋에 값이 변화될때마다 호출
    @objc func textDidChange(sender: UITextView) {
        if sender == emailTextField {
            loginViewModel.email = sender.text
        }
        else if sender == passwordTextField {
            loginViewModel.password = sender.text
        }
        loginBtn.backgroundColor = loginViewModel.btnColor
    }
}

//MARK: extension RegisterViewControllerDelegate
extension LoginViewController : RegisterViewControllerDelegate {
    func registerDidFinish() {
        // 회원가입 완료
        let controller = MainTabViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
