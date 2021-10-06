//
//  NoteListViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 9/2/21.
//

import Foundation
import RxSwift
import CoreLocation
import UserNotifications

protocol NoteListViewModelDelegate {
    func didFindNoteToAlarm()
    func didFinishMakeAlarm()
}

class NoteListViewModel {
    
    //MARK: properties
    var  noteList = [Note]()
    var disposebag : DisposeBag?
    var delegate : NoteListViewModelDelegate?
    
    //MARK: methods
    func updateNoteList() {
        
        // 현재 로그인된 유저아이디
        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] as? String else { return }
        guard let disposebag = disposebag else {return}
        
        // notes from db
        NoteService.shared.getNotesRX(userId: uid)
            .subscribe(onNext: { notes in
                self.noteList.removeAll()
                self.noteList = notes
            }, onError: {error in
                //  실패
                self.noteList.removeAll()
                self.noteList = [Note]() // 빈배열 할당
            }).disposed(by: disposebag)
    }
    
    // 전달받은 인자(위치정보)에서 쓰여진 노트가 있는지 체크
    func checkNoteWroteAt(location currentLocation : CLLocation?) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")

        // 노트들 하나씩 체크
        for (idx, noteItem) in noteList.enumerated() {
        
            // 노트 삭제 여부 확인
            let noteDeleted = noteItem.deleted
            if noteDeleted == 0 { // 삭제된 노트가 아님
                
                if let noteLatitude = Double(noteItem.latitude),
                   let noteLongitude = Double(noteItem.longitude),
                   let distance = currentLocation?.distance(from: CLLocation(latitude: noteLatitude, longitude: noteLongitude)), // 현재위치와 노트장소 사이거리
                   distance <= RETURN_RANGE, // 일정범위 이내이면 노트가 씌여진 장소로 돌와았다고 판정
                   let lastAlarmDate = formatter.date(from: noteItem.lastAlarmDate),
                   let writeDate = formatter.date(from:noteItem.writeDate)
                {
                    // 해당지역 RETURN_RANGE(돌아옴인식범위,200m) 이내로 다시방문한 경우
                    // distance : 노트쓴 장소와 현재 위치 거리차이
                    // lastAlarmDate : 마지막 알람 보낸 날짜
                    // writeDate : 노트 작성 날짜
                    
                    let intervalDay = lastAlarmDate.timeIntervalSinceNow / 86400 * -1 // 오늘과 마지막알람날짜 시간차이
                    let alaramCheck = noteItem.onOffAlarm // 해당 노트 알람 on/off 체크
                    
                    if intervalDay >= REMINDE_INTERVAL_DAY, alaramCheck == ALARM_ON {
                        // 알람on, REMINDE_INTERVAL_DAY(알람간격시간이 지났으면) -> 알람 보내기

                        // 업데이트 일시정지
                        delegate?.didFindNoteToAlarm()
                        
                        let todayStr = formatter.string(from: Date()) // 오늘날짜
                        let writeDateIntervalDay = writeDate.timeIntervalSinceNow / 86400 * -1 // 노트쓴 날짜로부터 오늘날짜 시간차이
                        
                        // db에 알람 전송날짜를 오늘로 갱신
                        NoteService.shared.updateLastAlarmDateRX(withNoteId: "\(noteItem.id)", newLastAlarmDate: todayStr)
                            .subscribe(onNext: { _ in // 갱신성공시 알람 보내기
                                
                                // 알람메세지
                                let content = UNMutableNotificationContent()
                                content.title = noteItem.title
                                content.body = "\(Int(writeDateIntervalDay))일전 그때 이곳에서 작성한 노트입니다."
                                content.badge = 1
                                content.sound = .default
                                let indexDict : [String:String] = ["index" : "\(idx)"]
                                content.userInfo = indexDict
                                
                                // 알람 전송
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                let req = UNNotificationRequest(identifier: "\(noteItem.id)", content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(req) { err in
                                    DispatchQueue.main.async { [weak self]  in
                                        if let error = err {
                                            // 전송실패
                                            print("debug : UNUserNotificationCenter  error -> \(error.localizedDescription)")
                                            self?.delegate?.didFinishMakeAlarm()
                                        }
                                        else{
                                            // 전송성공
                                            self?.delegate?.didFinishMakeAlarm()
                                        }
                                    }
                                }
                            }).disposed(by: self.disposebag ?? DisposeBag())
                    }
                }
            }
        } //  end for (idx, noteItem) in viewModel.noteList.enumerated()
        
    }
}
