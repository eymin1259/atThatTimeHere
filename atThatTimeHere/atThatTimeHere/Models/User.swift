//
//  User.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import Foundation

struct User {
    var id : Int
    var email : String
    var password : String
    
    var toDictionary : [String:String] {
        return  [
            "id" : "\(id)",
            "email": email,
            "password": password
        ]
    }
}
