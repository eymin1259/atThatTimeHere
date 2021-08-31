//
//  DBService.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import Foundation
import SQLite3


class DBService {
    
    static let shared = DBService()
    
    private init () {
        print("debug : DBService shared init ")
    }
    
    //MARK: database settings
    // db만들기
    
    // db 날리기
    
    // db refresh = 날리기 + 만들기
    
    //MARK: User
    func createUserTable() {
        do {
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY , email TEXT, password TEXT);")
            try db.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createUserDeviceTable() {
        do {
            let db = try SQLite()
            
            try db.install(query:"CREATE TABLE IF NOT EXISTS UserDevice (id INTEGER PRIMARY KEY , uid INTEGER, did INTEGER);")
            try db.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 아이디 존재?
    func getUserInfo(email: String, completion: @escaping(User?)->Void) {
        var user : User? = nil
        
        do{
            let db = try SQLite()
            try db.install(query:"SELECT * FROM Users  WHERE email ='\(email)'")
            try db.execute(){ stmt in
                let uid = Int(sqlite3_column_int(stmt, 0))
                let emailAddress = String(cString: sqlite3_column_text(stmt, 1))
                let password = String(cString: sqlite3_column_text(stmt, 2))
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
            try db.execute(){ stmt in
                let uid = Int(sqlite3_column_int(stmt, 0))
                let emailAddress = String(cString: sqlite3_column_text(stmt, 1))
                let password = String(cString: sqlite3_column_text(stmt, 2))
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
    
    func postdNote(){
        
    }
    
    func getNote(id:String){
        
    }
    
    func getLoteList(){
        
    }
    
}
