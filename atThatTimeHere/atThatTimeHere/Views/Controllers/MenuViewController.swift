//
//  MenuViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit

class MenuViewController: BaseViewController {
    // 메뉴 : 추억쓰기, 내정보, 앱버전정보, 이용약관, 별점과리뷰작성, 로그아웃
    
    //MARK: UI
    private lazy var  writeNoteLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("추억 쓰기", for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapWriteNote), for: .touchUpInside)
        return btn
    }()
    
    private var  settingLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("설정", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapSetting), for: .touchUpInside)
        return btn
    }()

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        writeNoteLbl.isHidden = false
        settingLbl.isHidden = false
    }

    //MARK: methods
    func setupUI(){
        
        // customize navigationController backButton
        let backBtn = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBtn.tintColor = CUSTOM_MAIN_COLOR
        navigationItem.backBarButtonItem = backBtn
        
        // 스택뷰 생성 -> writeNoteLbl, settingLbl 포함
        let stackView = UIStackView(arrangedSubviews: [writeNoteLbl, settingLbl])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    //MARK: actions
    @objc func didTapWriteNote(){
        // 추억 쓰기 버튼 클릭
        let newNote = NoteViewController()
        newNote.viewModel.isNewNote = true // 새로운 노트 작성
        newNote.modalPresentationStyle = .pageSheet
        newNote.viewModel.isNoteWithPhoto = false
        newNote.delegate = self
        present(newNote, animated: true, completion: nil)
    }
    
    @objc func didTapSetting(){
        // 설정버튼 클릭
        
        writeNoteLbl.isHidden = true
        settingLbl.isHidden = true
        
        let setting  = SettingViewController()
        navigationController?.pushViewController(setting, animated: true)
    }
}

//MARK: extension NoteViewControllerDelegate
extension MenuViewController : NoteViewControllerDelegate {
    func didSaveNote() {
        self.view.makeToast("노트를 저장했습니다.")
    }
}
