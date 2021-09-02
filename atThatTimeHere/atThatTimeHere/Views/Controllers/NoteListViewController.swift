//
//  NoteListViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit

class NoteListViewController: BaseViewController {
    
    // 추억보기
    //MARK: properties
    var tableView = UITableView()
    
    //MARK: UI
    private var  titleLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "추억 보기"
        text.font = UIFont(name: CUSTOM_FONT, size: 25)
        text.textColor = CUSTOM_MAIN_COLOR
        return text
    }()
    
    private var dividerView = DividerView()

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("debug : NoteListViewController viewWillAppear ")
        tableView.reloadData()
    }
    
    //MARK: methods
    func setupUI(){
        
        navigationController?.navigationBar.isHidden = true
        
        // 제목 ui
        view.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
    
        // 제목-내용 구분선 ui
        view.addSubview(dividerView)
        dividerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        dividerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        dividerView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 40).isActive = true
        dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true

        
        // 노트리스트 ui
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40).isActive = true
        tableView.separatorStyle = .none
    }

}

extension NoteListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NoteListTableViewCell()
        cell.setUpCell(index: indexPath.item, noteid: 777, title: "long  title asdasdasasd astitasda sdas ekkkkkkkkd ddddddd", date: "2011-12-13 11:23")
      //  cell.backgroundColor = .yellow
       //  cell.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteId = tableView.cellForRow(at: indexPath) as? NoteListTableViewCell
        
        print("debug : didSelectRowAt -> \(indexPath.item), note id -> \(noteId?.noteId)")
    }
    
}
