//
//  NoteListTableViewCell.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 9/2/21.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    
    //MARK: properties
    private var idx : Int?
    var noteId : Int?
    
    //MARK: UI
    
    // 제목
    private var titleLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "제목없음"
        lbl.textColor = .black
        lbl.font = UIFont(name: CUSTOM_FONT, size: 22)
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    // 날짜
    private var dateLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "2000-01-01"
        lbl.textColor = .gray
        lbl.font = UIFont(name: CUSTOM_FONT, size: 14)
        return lbl
    }()
    
    // 주소
    // private var locationLbl

    // MARK: life cycle
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        let bgView = UIView()
        bgView.backgroundColor = CUSTOM_MAIN_COLOR.withAlphaComponent(0.1)
        
        selectedBackgroundView = bgView
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 86).isActive = true
        selectedBackgroundView?.layer.cornerRadius = 15
   
        // 제목
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        // 날짜
        addSubview(dateLbl)
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5).isActive = true
        dateLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
         
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setUpCell(index :Int, noteid : Int, title: String, date : String){
        idx = index
        noteId = noteid
        titleLbl.text = title
        dateLbl.text = date
    }
    
  
}
