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
        lbl.text = "asd"
        lbl.textColor = .black
        lbl.font = UIFont(name: CUSTOM_FONT, size: 22)
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    // 날짜
    private var dateLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "aas"
        lbl.textColor = .gray
        lbl.font = UIFont(name: CUSTOM_FONT, size: 14)
        return lbl
    }()
    
    private var headerDivider = DividerView()
    
    private var goNoteBtn : UILabel = {
        let lbl = UILabel()
        lbl.text = ">"
        lbl.textColor = .black
        lbl.font = UIFont(name: CUSTOM_FONT, size: 22)
       // lbl.font = .systemFont(ofSize: 22)
        return lbl
    }()
    

    // MARK: life cycle
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        let bgView = UIView()
        bgView.backgroundColor = CUSTOM_MAIN_COLOR.withAlphaComponent(0.1)
        
        selectedBackgroundView = bgView
        backgroundColor = .clear
        
         heightAnchor.constraint(equalToConstant: 86).isActive = true
        
        
        
        selectedBackgroundView?.layer.cornerRadius = 15
        
//        addSubview(headerDivider)
//        headerDivider.translatesAutoresizingMaskIntoConstraints = false
//        headerDivider.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        headerDivider.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        headerDivider.rightAnchor.constraint(equalTo: rightAnchor, constant: 20).isActive =  true
        
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        //titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        
        addSubview(dateLbl)
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5).isActive = true
        dateLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
//        addSubview(goNoteBtn)
//        goNoteBtn.translatesAutoresizingMaskIntoConstraints = false
//        //goNoteBtn.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
//        goNoteBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
//        goNoteBtn.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        
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
    
    func setUpCell(index :Int, noteid : Int, title: String, date : String){
        idx = index
        noteId = noteid
        titleLbl.text = title
        
        dateLbl.text = date
        
        if idx == 0 {
            headerDivider.isHidden = true
        }
        headerDivider.isHidden = true
    }
    
  
}
