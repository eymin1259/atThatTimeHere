//
//  NoteViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import CoreLocation
import RxSwift

class NoteViewModel {
    
    //MARK: properties
    let disposeBag = DisposeBag()
    
    //  note attributes
    var isNewNote : Bool = false
    var isEditiing : Bool = false
    var isNoteWithPhoto : Bool = false
    
    // note data
    var noteId : Int?
    var noteImage : UIImage?
    var noteImageUrl : URL?
    
    // note location
    var currentLocation : CLLocation?
    
    //MARK: methods
    
    // 추억노트 만들기
    func createNote(userId uid : String, title: String, content: String) -> Observable<Bool>  {
        return Observable.create { [weak self] emitter in

            // 현재시간
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "ko_kr")
            let todayStr = formatter.string(from: today)
            
            // 디폴트좌표 -> 북극
            var latitude = CLLocationDegrees(78.231570)
            var longitude = CLLocationDegrees(15.574564)
            
            // 현재위치좌표
            if  let lati = self?.currentLocation?.coordinate.latitude, let  longi = self?.currentLocation?.coordinate.longitude {
                latitude = lati
                longitude = longi
            }
            
            // 이미지첨부된 노트 저장
            if let jpenData = self?.noteImage?.jpegData(compressionQuality: 1.0),
               let imgUrl = self?.noteImageUrl,
               let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imgUrl.lastPathComponent)
            {
                //  이미지 저장
                do {
                    try jpenData.write(to: filePath, options: .atomic)
                } catch {
                    // 이미지 저장 실패
                    print("debug : pngImage.write error -> \(error.localizedDescription)")
                    emitter.onError(error)
                }
                
                // 디비에 노트 저장
                NoteService.shared.createNoteTable()
                NoteService.shared.insertNoteRX(userId: uid, title: title, content: content, imagePath: filePath.absoluteString, writeDate: todayStr, latitude: "\(latitude)", longitude: "\(longitude)", lastAlarmDate: todayStr, onOffAlarm: ALARM_ON)
                    .subscribe(onNext: {_ in
                        // insert 성공
                        emitter.onNext(true)
                    }, onError: { error in
                        // insert 실패
                        emitter.onError(error)
                    }).disposed(by: self?.disposeBag ?? DisposeBag())
            }
            // 이미지 첨부되지 않은 노트
            else {
                // 디비에 저장
                NoteService.shared.createNoteTable()
                NoteService.shared.insertNoteRX(userId: uid, title: title, content: content, imagePath: "", writeDate: todayStr,  latitude: "\(latitude)", longitude: "\(longitude)", lastAlarmDate: todayStr, onOffAlarm: ALARM_ON)
                    .subscribe(onNext: {_ in
                        // insert 성공
                        emitter.onNext(true)
                    }, onError: { error in
                        // insert 실패
                        emitter.onError(error)
                    }).disposed(by: self?.disposeBag ?? DisposeBag())
            }
            return Disposables.create()
        }
    }

    
    // 추억노트 가져오기
    func readNote() -> Observable<Note> {
        return Observable.create {  [weak self] emitter in
            NoteService.shared.getNoteRX(ByNoteId: "\(self?.noteId ?? 0)")
                .subscribe(onNext: { note in
                    
                    // 뷰모델-위치데이터 바인딩
                    self?.currentLocation = CLLocation(latitude: Double(note.latitude) ?? 78.231570, longitude: Double(note.longitude) ?? 15.574564)
                    // 이미지정보 존재하면
                    if  let imageUrl = URL(string: note.imagePath) {
                        do {
                            // 뷰모델-이미지 바인딩
                            self?.noteImageUrl = imageUrl
                            let imageData = try Data(contentsOf: imageUrl)
                            self?.noteImage = UIImage(data: imageData)
                            emitter.onNext(note)
                        } catch {
                            print("Error loading image : \(error)")
                            emitter.onError(error)
                        }
                    }
                    else{ // 존재하지 않는 경우 노트정보 전달
                        emitter.onNext(note)
                    }
                }, onError: {error in
                    // 실패시 에러전달
                    emitter.onError(error)
                }).disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    // 추억노트 수정
    func updateNote(title: String, content: String) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in

            // 이미지첨부된 노트 수정
            if let jpenData = self?.noteImage?.jpegData(compressionQuality: 1.0),
               let imgUrl = self?.noteImageUrl,
               let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imgUrl.lastPathComponent)
            {
                //  이미지 저장
                do {
                    try jpenData.write(to: filePath, options: .atomic)
                } catch {
                    // 이미지 저장 실패
                    print("debug : pngImage.write error -> \(error.localizedDescription)")
                    emitter.onError(error)
                }
                // 디비에 노트 수정
                NoteService.shared.updateNoteRX(withNoteId: "\(self?.noteId ?? 0)", title: title, content: content, imagePath: filePath.absoluteString)
                    .subscribe(onNext: { _ in
                        // update 성공
                        emitter.onNext(true)
                    }, onError: { error in
                        // update 실패
                        emitter.onError(error)
                    }).disposed(by:self?.disposeBag ?? DisposeBag())
            }
            else { // 이미지 첨부되지 않은 노트 수정
                // 디비에 저장
                NoteService.shared.updateNoteRX(withNoteId: "\(self?.noteId ?? 0)", title: title, content: content)
                    .subscribe(onNext: { _ in
                        // update 성공
                        emitter.onNext(true)
                    }, onError: { error in
                        // update 실패
                        emitter.onError(error)
                    }).disposed(by: self?.disposeBag ?? DisposeBag())
            }
            return Disposables.create()
        }
    }
    
    // 추억노트 지우기
    func deleteNote() -> Observable<Bool> {
        return Observable.create {  [weak self] emitter in
            NoteService.shared.removeNoteRX(ByNoteId: "\(self?.noteId ?? 0)")
                .subscribe(onNext: { _ in
                    // 삭제 성공
                    emitter.onNext(true)
                }, onError: {error in
                    // 삭제 실패
                    emitter.onError(error)
                }).disposed(by:self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
  

}
