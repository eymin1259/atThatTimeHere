//
//  NoteService.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import Foundation
import SQLite3
import RxSwift

class NoteService {
    
    static let shared = NoteService()
    
    private init () {
        print("debug : DBService shared init ")
    }
    
    //MARK: database access
    func createNoteTable(){
        do {
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY , userId INTEGER, title TEXT, content TEXT, imagePath TEXT, writeDate TEXT, latitude TEXT, longitude TEXT, lastAlarmDate TEXT, onOffAlarm INTEGER, deleted INTEGER );")
            try db.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createNoteTableWithFirstNote(){
        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] else { return }
        do {
            // create note table
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY , userId INTEGER, title TEXT, content TEXT, imagePath TEXT, writeDate TEXT, latitude TEXT, longitude TEXT, lastAlarmDate TEXT, onOffAlarm INTEGER, deleted INTEGER );")
            try db.execute()
                                              
            // insert first note
            try db.install(query:"INSERT INTO Notes (userId, title, content, imagePath, writeDate, latitude, longitude, lastAlarmDate, onOffAlarm, deleted ) VALUES ('\(uid)', '환영합니다 :)', '그때이곳은 소중한 추억을 간직하는 추억알람앱 입니다. 의미있는 장소에서 추억노트를 작성해보세요. 훗날 그곳에 다시 갔을 때 그곳에서 작성했던 추억을 보여드릴께요 !', '', '', '78.231570', '15.574564' , '1999-12-31', '1', '0'  ); ")
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
            try db.install(query:"INSERT INTO Notes (userId, title, content, imagePath, writeDate, latitude, longitude, lastAlarmDate, onOffAlarm, deleted ) VALUES ('\(uid)', '\(checkedTitle)', '\(checkedContent)', '\(imagePath)', '\(writeDate)', '\(latitude)', '\(longitude)' , '\(lastAlarmDate)', '\(onOffAlarm)' ,'0'  ); ")
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
            try db.install(query:"SELECT * FROM Notes  WHERE userId = \(uid) AND deleted = '0' ORDER BY id DESC;")
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
                let note_deleted = Int(sqlite3_column_int(row, 10))
                
                let note = Note(id: note_id, userId: note_uid, title: note_title, content: note_content, imagePath: note_imagePath, writeDate: note_date, latitude: note_latitude, longitude: note_longitude, lastAlarmDate: note_lastAlarmDate, onOffAlarm: note_onOffAlarm, deleted: note_deleted)
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
            try db.install(query:"SELECT * FROM Notes  WHERE id = \(noteId) AND deleted = '0' ;")
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
                let note_deleted = Int(sqlite3_column_int(row, 10))
                
                let note = Note(id: note_id, userId: note_uid, title: note_title, content: note_content, imagePath: note_imagePath, writeDate: note_date, latitude: note_latitude, longitude: note_longitude, lastAlarmDate: note_lastAlarmDate, onOffAlarm: note_onOffAlarm, deleted: note_deleted)
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
    
    func updateNote(withNoteId noteId : String, title: String, content: String, imagePath:String = "", completion: @escaping(Bool)->Void){
        do{
            let db = try SQLite()
            try db.install(query:"UPDATE Notes SET title = '\(title)', content = '\(content)', imagePath = '\(imagePath)' WHERE id = '\(noteId)';")
            try db.execute()
            
            // update 성공
            completion(true)
            return
        }
        catch {
            print("debug : updateLastAlarmDate fail -> \(error.localizedDescription)")
        }
        // update 실패
        completion(false)
    }
    
    func removeNote(ByNoteId noteId: String, completion: @escaping(Bool) -> Void){
        do{
            let db = try SQLite()
            try db.install(query:"UPDATE Notes SET deleted = '1' WHERE id = '\(noteId)';")
            try db.execute()
            
            // 삭제성공
            completion(true)
            return
        }
        catch {
            print("debug : removeNote fail -> \(error.localizedDescription)")
        }
        // 삭제실패
        completion(false)
    }
}
