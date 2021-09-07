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
    
    func getUserInfo(byEmail email : String, completion: @escaping(User?)->Void) {
        var user : User? = nil
        
        do{
            let db = try SQLite()
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
    
    //MARK: Note
    func createNoteTable(){
        do {
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY , userId INTEGER, title TEXT, content TEXT, imagePath TEXT, writeDate TEXT, latitude TEXT, longitude TEXT, lastAlarmDate TEXT, onOffAlarm INTEGER );")
            try db.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func insertNote(title: String, content: String, imagePath:String = "", writeDate:String, latitude:String, longitude:String, lastAlarmDate:String , onOffAlarm : Int, completion: @escaping(Bool)->Void){
        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] else { return }
        var checkedTitle = title
        if title == "" {
            checkedTitle = "제목없음"
        }
        var checkedContent = content
        if content == "" {
            checkedContent = "."
        }
        do{
            // insert note data
            let db = try SQLite()
            try db.install(query:"INSERT INTO Notes (userId, title, content, imagePath, writeDate, latitude, longitude, lastAlarmDate, onOffAlarm ) VALUES ('\(uid)', '\(checkedTitle)', '\(checkedContent)', '\(imagePath)', '\(writeDate)', '\(latitude)', '\(longitude)' , '\(lastAlarmDate)', '\(onOffAlarm)'  ); ")
            try db.execute()
            
            completion(true)
            return
        }
        catch {
            print("debug : insertNote fail -> \(error.localizedDescription)")
        }
        completion(false)
    }
    
    func getNotes(completion: @escaping(Bool, [Note]?) -> Void){

        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] else { return }
        var ret = [Note]()
        
        do{
            let db = try SQLite()
            try db.install(query:"SELECT * FROM Notes  WHERE userId = \(uid) ORDER BY id DESC;")
            try db.execute(){ row in
                let note_id = Int(sqlite3_column_int(row, 0))
                let note_uid = Int(sqlite3_column_int(row, 1))
                let note_title = String(cString: sqlite3_column_text(row, 2))
                let note_content = String(cString: sqlite3_column_text(row, 3))
                let note_imagePath = String(cString: sqlite3_column_text(row, 4))
                let note_date = String(cString: sqlite3_column_text(row, 5))
                let note_latitude = String(cString: sqlite3_column_text(row, 6))
                let note_longitude = String(cString: sqlite3_column_text(row, 7))
                let note_lastAlarmDate = String(cString: sqlite3_column_text(row, 8))
                let note_onOffAlarm = Int(sqlite3_column_int(row, 9))
                
                let note = Note(id: note_id, userId: note_uid, title: note_title, content: note_content, imagePath: note_imagePath, writeDate: note_date, latitude: note_latitude, longitude: note_longitude, lastAlarmDate: note_lastAlarmDate, onOffAlarm: note_onOffAlarm)
                ret.append(note)
            }
            
            completion(true, ret)
            return
        }
        catch {
            print("debug : getNotes fail -> \(error.localizedDescription)")
        }
        completion(false, nil)
    }
    
    func getNote(ByNoteId noteId: String, completion: @escaping(Bool, Note?) -> Void){
        do{
            let db = try SQLite()
            try db.install(query:"SELECT * FROM Notes  WHERE id = \(noteId);")
            try db.execute(){ row in
                let note_id = Int(sqlite3_column_int(row, 0))
                let note_uid = Int(sqlite3_column_int(row, 1))
                let note_title = String(cString: sqlite3_column_text(row, 2))
                let note_content = String(cString: sqlite3_column_text(row, 3))
                let note_imagePath = String(cString: sqlite3_column_text(row, 4))
                let note_date = String(cString: sqlite3_column_text(row, 5))
                let note_latitude = String(cString: sqlite3_column_text(row, 6))
                let note_longitude = String(cString: sqlite3_column_text(row, 7))
                let note_lastAlarmDate = String(cString: sqlite3_column_text(row, 8))
                let note_onOffAlarm = Int(sqlite3_column_int(row, 9))
                
                let note = Note(id: note_id, userId: note_uid, title: note_title, content: note_content, imagePath: note_imagePath, writeDate: note_date, latitude: note_latitude, longitude: note_longitude, lastAlarmDate: note_lastAlarmDate, onOffAlarm: note_onOffAlarm)
                completion(true, note)
            }
            return
        }
        catch {
            print("debug : getNotes fail -> \(error.localizedDescription)")
        }
        completion(false, nil)
    }
    
    func updateLastAlarmDate(withNoteId noteId : String, newLastAlarmDate : String, completion: @escaping(Bool) -> Void){
        do{
            let db = try SQLite()
            try db.install(query:"UPDATE Notes SET lastAlarmDate = '\(newLastAlarmDate)' WHERE id = '\(noteId)';")
            try db.execute()
            completion(true)
            return
        }
        catch {
            print("debug : updateLastAlarmDate fail -> \(error.localizedDescription)")
        }
        completion(false)
    }
}
