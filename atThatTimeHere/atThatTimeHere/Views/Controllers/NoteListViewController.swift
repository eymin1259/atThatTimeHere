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
    var noteListViewModel = NoteListViewModel()
    
    //MARK: UI
    
    // 타이틀
    private var  titleLbl :  UILabel  =  {
        let  text = UILabel()
        text.text = "추억 보기"
        text.font = UIFont(name: CUSTOM_FONT, size: 25)
        text.textColor = CUSTOM_MAIN_COLOR
        return text
    }()
    
    // 구분선
    private var dividerView = DividerView()
    
    // 노트 테이블뷰
    var tableView = UITableView()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.reloadData()

        setupUI()
        
        // 알람 클릭시 발송되는 noti 인식 -> show note
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePushAlarm), name: NSNotification.Name(rawValue: DID_RECEIVE_PUSH_ALARM), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("debug : NoteListViewController viewWillAppear ")
        noteListUpdate()
        print("Debug : notelIst check -> \(noteListViewModel.noteList)")
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

    func noteListUpdate(){
        noteListViewModel.updateNoteList()
        tableView.reloadData()
    }
    
    //MARK: actions
    
    @objc func didReceivePushAlarm(noti : Notification){
        if let data = noti.userInfo as? [String:String], let nid = data["nid"], let noteId = Int(nid), let idx = data["index"], let idxInt = Int(idx) {
            // nid : 알람에 해당하는 노트id
            // idxInt : 알람에해당하는 노트의 index
            
            // note show
            let newNote = NoteViewController()
            newNote.viewModel.isNewNote = false // 기존 노트 불러오기
            newNote.modalPresentationStyle = .pageSheet
            newNote.viewModel.isNoteWithPhoto = noteListViewModel.noteList[idxInt].imagePath == "" ? false : true
            newNote.viewModel.noteId = noteId
            present(newNote, animated: true, completion: nil)
            
        }else{
            print("Debug : no data")
        }
    }
}

//MARK: extension UITableViewDelegate
extension NoteListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListViewModel.noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NoteListTableViewCell()
        cell.setUpCell(index: indexPath.item, noteid:  noteListViewModel.noteList[indexPath.item].id, title: noteListViewModel.noteList[indexPath.item].title, date: noteListViewModel.noteList[indexPath.item].writeDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 추억보기
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 선택된 노트의 id
        guard let noteCell = tableView.cellForRow(at: indexPath) as? NoteListTableViewCell else {return}
        
        // note 정보로드
        let newNote = NoteViewController()
        newNote.viewModel.isNewNote = false // 기존 노트 불러오기
        newNote.modalPresentationStyle = .pageSheet
        newNote.viewModel.isNoteWithPhoto = noteListViewModel.noteList[indexPath.item].imagePath == "" ? false : true
        newNote.viewModel.noteId = noteCell.noteId
        present(newNote, animated: true, completion: nil)
    }
}
