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
    
    //MARK: database
    
    //MARK: createNoteTable
    func createNoteTable(){
        do {
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY , userId INTEGER, title TEXT, content TEXT, imagePath TEXT, writeDate TEXT, latitude TEXT, longitude TEXT, lastAlarmDate TEXT, onOffAlarm INTEGER, deleted INTEGER );")
            try db.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: createNoteTableWithFirstNote
    func createNoteTableWithFirstNote(userId : String ){
        do {
            // create note table
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY , userId INTEGER, title TEXT, content TEXT, imagePath TEXT, writeDate TEXT, latitude TEXT, longitude TEXT, lastAlarmDate TEXT, onOffAlarm INTEGER, deleted INTEGER );")
            try db.execute()
                                              
            // insert first note
            try db.install(query:"INSERT INTO Notes (userId, title, content, imagePath, writeDate, latitude, longitude, lastAlarmDate, onOffAlarm, deleted ) VALUES ('\(userId)', '\("default_title".localized())', '\("default_body".localized())', '', '', '78.231570', '15.574564' , '2099-12-31', '1', '0'  ); ")
            try db.execute()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: insertNote
    func insertNote(title: String, content: String, imagePath:String = "", writeDate:String, latitude:String, longitude:String, lastAlarmDate:String , onOffAlarm : Int, completion: @escaping(Bool)->Void){
        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] else { return }
        var checkedTitle = title
        if title == "" {
            checkedTitle = "untitled".localized()
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
    
    // insertNote reactive 적용
    func insertNoteRX(userId uid : String, title: String, content: String, imagePath:String = "", writeDate:String, latitude:String, longitude:String, lastAlarmDate:String , onOffAlarm : Int) -> Observable<Bool> {
        return Observable.create { emitter in
            
            var checkedTitle = title
            if title == "" {
                checkedTitle = "untitled".localized()
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
                emitter.onNext(true)
            }
            catch {
                print("debug : insertNote fail -> \(error.localizedDescription)")
                emitter.onError(error)
            }
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: getNotes
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
    
    // getNotes reactive 적용
    func getNotesRX(userId uid : String ) -> Observable<[Note]> {
        return Observable.create { emitter in
            // 리턴값
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
                    
                    // 노트데이터
                    let note = Note(id: note_id, userId: note_uid, title: note_title, content: note_content, imagePath: note_imagePath, writeDate: note_date, latitude: note_latitude, longitude: note_longitude, lastAlarmDate: note_lastAlarmDate, onOffAlarm: note_onOffAlarm, deleted: note_deleted)
                    ret.append(note)
                }
                emitter.onNext(ret)
            }
            catch {
                print("debug : getNotes fail -> \(error.localizedDescription)")
                emitter.onError(error)
            }
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: getNote
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
    
    // getNote reactive 적용
    func getNoteRX(ByNoteId noteId: String) -> Observable<Note> {
        return Observable.create { emitter in
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
                    emitter.onNext(note)
                }
            }
            catch {
                print("debug : getNotes fail -> \(error.localizedDescription)")
                emitter.onError(error)
            }
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    
    //MARK: updateLastAlarmDate
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
     
    // updateLastAlarmDate reactive 적용
    func updateLastAlarmDateRX(withNoteId noteId : String, newLastAlarmDate : String) -> Observable<Bool> {
        return Observable.create { emitter in
            
            do{
                let db = try SQLite()
                try db.install(query:"UPDATE Notes SET lastAlarmDate = '\(newLastAlarmDate)' WHERE id = '\(noteId)';")
                try db.execute()
                emitter.onNext(true)
            }
            catch {
                print("debug : updateLastAlarmDateRX fail -> \(error.localizedDescription)")
                emitter.onError(error)
            }
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: updateNote
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
    
    // updateNote reactive 적용
    func updateNoteRX(withNoteId noteId : String, title: String, content: String, imagePath:String = "") -> Observable<Bool> {
        return Observable.create { emitter in
            do{
                let db = try SQLite()
                try db.install(query:"UPDATE Notes SET title = '\(title)', content = '\(content)', imagePath = '\(imagePath)' WHERE id = '\(noteId)';")
                try db.execute()
                // update 성공
                emitter.onNext(true)
            }
            catch {
                // update 실패
                print("debug : updateNoteRX fail -> \(error.localizedDescription)")
                emitter.onError(error)
            }
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: removeNote
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
    
    // removeNote reactive 적용
    func removeNoteRX(ByNoteId noteId: String) -> Observable<Bool> {
        return Observable.create { emitter in
            do{
                let db = try SQLite()
                try db.install(query:"UPDATE Notes SET deleted = '1' WHERE id = '\(noteId)';")
                try db.execute()
                
                // 삭제성공
                emitter.onNext(true)
            }
            catch {
                // 삭제실패
                print("debug : removeNoteRX fail -> \(error.localizedDescription)")
                emitter.onError(error)
            }
            emitter.onCompleted()
            return Disposables.create()
        }
    }
}
