//
//  Note.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/31/21.
//

import Foundation

struct Note {
    var id : Int // 노트아이디
    var userId : Int // 글쓴이 아이디
    var title : String // 제목
    var content : String // 내용
    var imagePath : String // 이미지패스
    var writeDate : String // 작성 날짜
    var latitude : String // 위도
    var longitude : String // 경도
    var lastAlarmDate : String // 마지막 알람날짜
    var onOffAlarm : Int // 알람on/off : ALARM_ON(0) = on, ALARM_OFF(-1) = off
    var deleted : Int // 삭제여부 : 0=삭제x, 1=삭제o
    
    var toNoteDictionary : [String:String] {
        return  [
            "id" : "\(id)",
            "userId": "\(userId)",
            "title": title,
            "content": content,
            "imagePath": imagePath,
            "writeDate": writeDate,
            "latitude" : latitude,
            "longitude" : longitude,
            "lastAlarmDate" : lastAlarmDate,
            "onOffAlarm" : "\(onOffAlarm)",
            "deleted" : "\(deleted)"
        ]
    }
}
