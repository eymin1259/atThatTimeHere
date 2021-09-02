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
    var noteListViewModel = NoteListViewModel()
    
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
        //tableView.reloadData()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("debug : NoteListViewController viewWillAppear ")
        noteListUpdate()
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
        noteListViewModel.getNoteList()
        tableView.reloadData()
    }
}

//MARK: extension UITableViewDelegate
extension NoteListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListViewModel.noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NoteListTableViewCell()
        cell.setUpCell(index: indexPath.item, noteid:  noteListViewModel.noteList[indexPath.item].id, title: noteListViewModel.noteList[indexPath.item].title, date: noteListViewModel.noteList[indexPath.item].date)
      //  cell.backgroundColor = .yellow
       //  cell.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 추억보기
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 선택된 노트의 id
        guard let noteCell = tableView.cellForRow(at: indexPath) as? NoteListTableViewCell else {return}
        print("debug : didSelectRowAt -> \(indexPath.item), note id -> \(noteCell.noteId)")
        
        // note 정보로드
        let newNote = NoteViewController()
        newNote.viewModel.isNewNote = false // 기존 노트 불러오기
        newNote.modalPresentationStyle = .pageSheet
        newNote.viewModel.isNoteWithPhoto = noteListViewModel.noteList[indexPath.item].imagePath == "" ? false : true
        newNote.viewModel.noteId = noteCell.noteId
        present(newNote, animated: true, completion: nil)
    }
}
