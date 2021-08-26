//
//  NoteListViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit

class NoteListViewController: UIViewController {
    
    // 추억보기
    //MARK: properties
    var tableView = UITableView()
    
    //MARK: UI
    private var  titleLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "추억 보기"
        text.font = UIFont(name: CUSTOM_FONT, size: 20)
        return text
    }()
    
    private var dividerView = DividerView()

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("debug : NoteListViewController viewWillAppear ")
        tableView.reloadData()
    }
    
    //MARK: methods
    func setupUI(){
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
    
        view.addSubview(dividerView)
        dividerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        dividerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        dividerView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 45).isActive = true
    
    }

}
