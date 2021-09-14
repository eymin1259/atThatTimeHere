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
        return formValid ? CUSTOM_MAIN_COLOR : CUSTOM_MAIN_COLOR.withAlphaComponent(0.3)
    }
    
    var alertColor : UIColor {
        if let emailVal = email, isValidEmail(emailVal) == false {
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else if let passwordVal = password, let passworkCheckVal = passwordCheck, passwordVal != passworkCheckVal {
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    
    var alertMessage : String {
        if let emailVal = email, isValidEmail(emailVal) == false {
            return "이메일 형식이 올바르지 않습니다."
        }
        else if let passwordVal = password, let passworkCheckVal = passwordCheck, passwordVal != passworkCheckVal {
            return "비밀번호가 일치하지 않습니다."
        }
        return " "
        
    }
    
    //MARK: methods
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
