//
//  AuthViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

struct AuthViewModel {
    
    //MARK: properties
    var email: String?
    var password: String?
    var passwordCheck : String?
    var isRegisterAuth = true
    
    var formValid : Bool {
        if isRegisterAuth { // 회원가입
            if email?.isEmpty == false, let passwordVal = password, passwordVal.isEmpty == false, let passworkCheckVal = passwordCheck, passworkCheckVal.isEmpty == false, passwordVal == passworkCheckVal {
                return true
            }
            return false
        }
        else { // 로그인
            if email?.isEmpty == false && password?.isEmpty == false {
                return  true
            }
            return false
        }
    }
    
    var btnColor : UIColor {
        return formValid ? CUSTOM_SKYBLUE : CUSTOM_SKYBLUE.withAlphaComponent(0.3)
    }
    
    var alertColor : UIColor {
        if let passwordVal = password, let passworkCheckVal = passwordCheck, passwordVal == passworkCheckVal {
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    var alertMessage : String {
        if let passwordVal = password, let passworkCheckVal = passwordCheck, passwordVal == passworkCheckVal {
            return " "
        }
        return "비밀번호가 일치하지 않습니다."
    }
    
    //MARK: methods
    func login(completion: @escaping(Bool, String)->Void) {
        UserService.shared.login(email: self.email ?? "", password: self.password ?? "") { (loginResult, loginMsg) in
            completion(loginResult, loginMsg)
        }
    }
    
    func register(completion: @escaping(Bool, String)->Void) {
        UserService.shared.signUp(email: self.email ?? "", password: self.password ?? "") { (registerRes, Msg) in
            completion(registerRes, Msg)
        }
    }
}
