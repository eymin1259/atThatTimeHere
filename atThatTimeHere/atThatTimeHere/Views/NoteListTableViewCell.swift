//
//  NoteListTableViewCell.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 9/2/21.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    
    //MARK: properties
    private var noteId : Int?
    
    //MARK: UI
    
    // 제목
    private var titleLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        return lbl
    }()
    
    // 날짜
    private var dateLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        return lbl
    }()
    

    // MARK: life cycle
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
//         addSubview(profileImageView)
//         profileImageView.setDimensions(height: 50, width: 50)
//         profileImageView.layer.cornerRadius = 50 / 2
//         profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
//         
//         let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
//         stack.axis = .vertical
//         stack.spacing = 5
//         stack.alignment = .leading
//         addSubview(stack)
//         stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10)
         
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setUpCell(id : Int, title: String, date : String){
        noteId = id
        titleLbl.text = title
        dateLbl.text = date
    }
}
