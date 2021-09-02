//
//  RegisterViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit

protocol  RegisterViewControllerDelegate {
    func registerDidFinish()
}

class RegisterViewController: BaseViewController {
    
    //MARK: properties
    var delegate : RegisterViewControllerDelegate?
    var registerViewModel : AuthViewModel = {
        var vm = AuthViewModel()
        vm.isRegisterAuth = true
        return vm
    }()
    
    //MARK: UI
    private let hatView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 3).isActive  = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let registerTitleLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "회원가입"
        text.textColor = CUSTOM_MAIN_COLOR.withAlphaComponent(0.8)
        text.font = UIFont(name: CUSTOM_FONT, size: 30)
        return text
    }()
    
    private let emailTextField : UITextField = {
        let tf = TextFieldWithPlaceholder(placeholder: "사용할 ID를 입력하세요")
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no

        return tf
    }()
    private let passwordTextField : UITextField = {
        let tf = TextFieldWithPlaceholder(placeholder: "사용할 password를 입력하세요")
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.textContentType = .oneTimeCode
        return tf
    }()
    
    private let passwordCheckTextField : UITextField = {
        let tf = TextFieldWithPlaceholder(placeholder: "password를 한번더 입력하세요")
        tf.isSecureTextEntry = true
        tf.textContentType = .oneTimeCode
        tf.autocorrectionType = .no
        return tf
    }()
    private let passwordAlertLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = " "
        text.font = UIFont(name: CUSTOM_FONT, size: 15)
        return text
    }()
    private let signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("확인", for: .normal)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.9), for: .normal)
        // btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.backgroundColor = CUSTOM_MAIN_COLOR.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addTarget(self, action: #selector(handleSingup), for: .touchUpInside)
        return btn
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("debug : RegisterViewController viewDidLoad")
        
        setupUI()
        configureNotificationObserver()
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: methods
    private func setupUI(){
        
        view.backgroundColor = .white
        
        view.addSubview(hatView)
        hatView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        hatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        hatView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(registerTitleLbl)
        registerTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        registerTitleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        registerTitleLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -230).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, passwordCheckTextField, passwordAlertLbl])
        stackView.axis = .vertical
        stackView.spacing = 1
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: registerTitleLbl.bottomAnchor, constant: 20).isActive =  true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(signupBtn)
        signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        signupBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signupBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordCheckTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // 화면터치시 키보드 내리기
        self.view.endEditing(true)
    }
    
    // MARK: actions
    @objc func handleSingup(){
        view.endEditing(true)
        showLoading()
        registerViewModel.register { (resultBoolean, resultMsg) in
            self.hideLoading()
            self.view.makeToast(resultMsg)
            
            if resultBoolean { // 회원가입 성공
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true) {
                        self.delegate?.registerDidFinish()
                    }
                }
            }
        }
    }
    
    @objc func textDidChange(sender: UITextView) {
        if sender == emailTextField {
            registerViewModel.email = sender.text
        }
        else if sender == passwordTextField {
            registerViewModel.password = sender.text
        }
        else if sender == passwordCheckTextField {
            registerViewModel.passwordCheck = sender.text
            passwordAlertLbl.textColor = registerViewModel.alertColor
            passwordAlertLbl.text = registerViewModel.alertMessage
        }
        signupBtn.backgroundColor = registerViewModel.btnColor
        signupBtn.isEnabled = registerViewModel.formValid
    }
    
}
