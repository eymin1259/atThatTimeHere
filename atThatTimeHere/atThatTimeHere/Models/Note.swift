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
    var context : String // 내용
    var imagePath : String // 이미지패스
    var date : String // 날짜
    
    var toNoteDictionary : [String:String] {
        return  [
            "id" : "\(id)",
            "userId": "\(userId)",
            "title": title,
            "context": context,
            "imagePath": imagePath,
            "date": date
        ]
    }
}
