//
//  UserService.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import Foundation
import CryptoSwift

class  AuthService  {
    
    static let shared = AuthService()
    
    private init () {
        print("debug : UserService shared init ")
    }
    
    // MARK: logout
    func logout() {
        UserDefaults.standard.removeObject(forKey: CURRENTUSERKEY)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: login
    func login(email: String, password: String, completion: @escaping(Bool, String)->Void) {
        
        guard let encryptedPassword = self.encryptPassword(password: password) else {
            completion(false, SYSTEM_ERROR_MESSAGE + "1")
            return
        }
        
        DBService.shared.getUserInfo(byEmail: email) { (userInDb) in
            if let user = userInDb {
                if user.password == encryptedPassword {
                    self.saveUserInfoLocally(user: user)
                    completion(true, "로그인 성공!")
                    return
                }
                else {
                    completion(false, "비밀번호를 다시 확인하세요.")
                    return
                }
            }
            else {
                completion(false, "존재하지 않는 아이디입니다.")
                return
            }
        }
    }
    
    // MARK: sign up
    func signUp(email: String, password: String, completion: @escaping(Bool, String)->Void) {
        DBService.shared.createUserTable()
        DBService.shared.getUserInfo(byEmail: email) { (userInDb) in
            if let _ = userInDb {
                completion(false, "이미 존재하는 이메일입니다.")
                return
            }
            else {
                guard let encryptedPassword = self.encryptPassword(password: password) else {
                    completion(false, SYSTEM_ERROR_MESSAGE  + " 2")
                    return
                }
                DBService.shared.insertUserInfo(email: email, password: encryptedPassword, photoUrl: nil) { (result, user) in
                    if result == true, let user =  user {
                        self.saveUserInfoLocally(user: user)
                        completion(true, "회원가입 성공!")
                        return
                    }else {
                        completion(false, SYSTEM_ERROR_MESSAGE + " 3")
                        return
                    }
                }
            }
        }
    }
    
    func creatAppleTestAccount(email: String = "appletest@apple.com", password: String = "appletest") {
        DBService.shared.createUserTable()
        DBService.shared.getUserInfo(byEmail: email) { (userInDb) in
            if let _ = userInDb {
                return
            }
            else {
                guard let encryptedPassword = self.encryptPassword(password: password) else {
                    return
                }
                DBService.shared.insertUserInfo(email: email, password: encryptedPassword, photoUrl: nil) { (result, user) in
                    if result == true, let _ =  user {
                        return
                    }else {
                        return
                    }
                }
            }
        }
    }
    
    // MARK: encryptPassword
    private func encryptPassword(password: String) -> String? {
        print("debug : UserService encryptPassword")
        var ret : String? = nil
        do {
            let aes = try AES(key: PASSWORD_SECRET_KEY, iv: PASSWORD_SECRET_IV)
            ret = try aes.encrypt(password.bytes).toBase64()
        } catch {
            print(error.localizedDescription)
        }
        return ret
    }
    
    private func saveUserInfoLocally(user : User){
        print("debug : saveUserInfoLocally -> user : \(user.toDictionary)")
        UserDefaults.standard.set(user.toDictionary, forKey: CURRENTUSERKEY)
        UserDefaults.standard.synchronize()
    }
}
