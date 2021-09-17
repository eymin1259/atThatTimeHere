//
//  AuthService.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import Foundation
import CryptoSwift
import  SQLite3
import RxSwift

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
        
        AuthService.shared.getUserInfo(byEmail: email) { (userInDb) in
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
    
    // login reactive 적용
    func loginRX(email: String, password: String) -> Observable<(String)> {
        return Observable.create {  emitter in
            // 암호 복호화
            if let encryptedPassword = self.encryptPassword(password: password) {
                self.getUserInfo(byEmail: email) { (userInDb) in
                    // 디비의 해당 이메일의 유저 정보
                    if let user = userInDb {
                        if user.password == encryptedPassword {
                            // 로그인 유저 정보 저장
                            self.saveUserInfoLocally(user: user)
                            emitter.onNext("로그인 성공!")
                            return
                        }
                        else { // 패스워드 불일치
                            emitter.onError(CustomError(errorMessage: "비밀번호를 다시 확인하세요."))
                            return
                        }
                    }
                    else {
                        // 디비의 해당 이메일의 유저 정보 없는경우
                        emitter.onError(CustomError(errorMessage: "존재하지 않는 아이디입니다."))
                        return
                    }
                }
                emitter.onCompleted()
            }
            else {
                // 암호 복호화 실패
                emitter.onError(CustomError(errorMessage: "비밀번호 시스템 오류 입니다."))
            }
            return Disposables.create()
        }
    }
    
    // MARK: sign up
    func signUp(email: String, password: String, completion: @escaping(Bool, String)->Void) {
        createUserTable()
        getUserInfo(byEmail: email) { (userInDb) in
            if let _ = userInDb {
                completion(false, "이미 존재하는 이메일입니다.")
                return
            }
            else {
                guard let encryptedPassword = self.encryptPassword(password: password) else {
                    completion(false, SYSTEM_ERROR_MESSAGE  + " 2")
                    return
                }
                self.insertUserInfo(email: email, password: encryptedPassword, photoUrl: nil) { (result, user) in
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
    
    // signUp reactive 적용
    func signUpRX(email: String, password: String) -> Observable<(String)> {
        // user table 생성
        createUserTable()
        
        return Observable.create {  emitter in
            
            self.getUserInfo(byEmail: email) { userInDb in
                // 이미 해당 이메일 존재하는 경우
                if let _ = userInDb {
                    emitter.onError(CustomError(errorMessage: "이미 존재하는 이메일입니다."))
                    return
                }
                else {
                    guard let encryptedPassword = self.encryptPassword(password: password) else {
                        // 암호 복호화 에러
                        emitter.onError(CustomError(errorMessage: "비밀번호 시스템 오류 입니다."))
                        return
                    }
                    self.insertUserInfo(email: email, password: encryptedPassword, photoUrl: nil) { (result, user) in
                        // db insert 성공
                        if result == true, let user =  user {
                            // 유저정보 Local 저장
                            self.saveUserInfoLocally(user: user)
                            emitter.onNext("회원가입 성공!")
                            emitter.onCompleted()
                        }else {
                            // db insert 실패
                            emitter.onError(CustomError(errorMessage: "시스템 오류, 관리자에게 문의바랍니다."))
                            return
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK: creatAppleTestAccount
    func creatAppleTestAccount(email: String = "appletest@apple.com", password: String = "appletest") {
        createUserTable()
        getUserInfo(byEmail: email) { (userInDb) in
            // appletest@apple.com 이미존재하는경우
            if let _ = userInDb {
                return
            }
            else { // appletest@apple.com 존재하지 않는경우
                guard let encryptedPassword = self.encryptPassword(password: password) else {
                    return
                }
                self.insertUserInfo(email: email, password: encryptedPassword, photoUrl: nil) { (result, user) in
                    // appletest@apple.com 생성 성공
                    if result == true, let appleAccount =  user {
                        NoteService.shared.createNoteTableWithFirstNote(userId: "\(appleAccount.id)")
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
        // 암호 복호화
        var ret : String? = nil
        do {
            let aes = try AES(key: PASSWORD_SECRET_KEY, iv: PASSWORD_SECRET_IV)
            ret = try aes.encrypt(password.bytes).toBase64()
        } catch {
            print(error.localizedDescription)
        }
        return ret
    }
    
    // MARK: saveUserInfoLocally
    private func saveUserInfoLocally(user : User){
        // 유저정보 로컬저장
        UserDefaults.standard.set(user.toDictionary, forKey: CURRENTUSERKEY)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: Database
    func createUserTable() {
        do {
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY , email TEXT, password TEXT);")
            try db.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 이메일로 유저정보 가져오기
    func getUserInfo(byEmail email : String, completion: @escaping(User?)->Void) {
        var user : User? = nil
        
        do{
            let db = try SQLite()
            // sql 쿼리
            try db.install(query:"SELECT * FROM Users  WHERE email ='\(email)'")
            try db.execute(){ row in
                let uid = Int(sqlite3_column_int(row, 0))
                let emailAddress = String(cString: sqlite3_column_text(row, 1))
                let password = String(cString: sqlite3_column_text(row, 2))
                user = User(id: uid, email: emailAddress, password: password)
            }
            completion(user)
            return
        }
        catch {
            print(error.localizedDescription)
        }
        completion(nil)
    }
    
    func insertUserInfo(email: String, password: String, photoUrl:String?, completion: @escaping(Bool, User?)->Void){
        do{
            let db = try SQLite()
            try db.install(query:"INSERT INTO Users (email, password) VALUES ('\(email)', '\(password)')")
            try db.execute()
            var user : User?  =  nil
            try db.install(query:"SELECT * FROM Users  WHERE email ='\(email)'")
            try db.execute(){ row in
                let uid = Int(sqlite3_column_int(row, 0))
                let emailAddress = String(cString: sqlite3_column_text(row, 1))
                let password = String(cString: sqlite3_column_text(row, 2))
                user = User(id: uid, email: emailAddress, password: password)
            }
            completion(true, user)
            return
        }
        catch {
            print("debug : insertUserInfo fail -> \(error.localizedDescription)")
        }
        completion(false, nil)
    }
    
}
