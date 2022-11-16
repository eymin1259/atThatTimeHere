//
//  AuthViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit
import RxSwift

struct AuthViewModel {
    
    //MARK: properties
    var email: String?
    var password: String?
    var passwordCheck : String?
    var isRegisterAuth = true
    let disposeBag = DisposeBag()

    
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
            return "invalid_email_format".localized()
        }
        else if let passwordVal = password, let passworkCheckVal = passwordCheck, passwordVal != passworkCheckVal {
            return "incorrect_login_input".localized()
        }
        return " "
        
    }
    
    //MARK: methods
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // 회원가입
    func signup() -> Observable<(String)> {
        return Observable.create {  emitter in
            AuthService.shared.signUpRX(email: email ?? "", password: password ?? "")
                .subscribe(onNext: {resultMsg in
                    // 초기 note table 세팅
                    guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] as? String else { return }
                    NoteService.shared.createNoteTableWithFirstNote(userId: uid)
                    // 메세지 전달
                    emitter.onNext(resultMsg)
                    emitter.onCompleted()
                }, onError: {error in
                    // 실패시 에러전달
                    emitter.onError(error)
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    //로그인
    func login() -> Observable<(String)> {
        return Observable.create {  emitter in
            AuthService.shared.loginRX(email: email ?? "", password: password ?? "")
                .subscribe(onNext: {resultMsg in
                    // 성공시 성공메세지 전달
                    emitter.onNext(resultMsg)
                    emitter.onCompleted()
                }, onError: {error in
                    // 실패시 에러전달
                    emitter.onError(error)
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
