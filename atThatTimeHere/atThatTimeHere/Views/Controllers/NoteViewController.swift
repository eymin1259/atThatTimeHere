//
//  NoteViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit

class NoteViewController: BaseViewController {
    
    //MARK: properties
    var viewModel = NoteViewModel()
    var contextViewBottomLayoutConstraint : NSLayoutConstraint?
//    var photoView
    
    //MARK: UI
    var dividerView = DividerView()
    
    var hatView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 3).isActive  = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    var titleTextField : TextFieldWithPlaceholder = {
        var tf = TextFieldWithPlaceholder(placeholder: "제목", fontSize: 30)
        tf.keyboardType = .default
        tf.autocorrectionType = .no
        return tf
    }()
    
    var photoView : PhotoView = {
       var view = PhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    var contextTextView : UITextView = {
        var tv = UITextView()
        tv.keyboardType = .default
        tv.autocorrectionType = .no
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .green.withAlphaComponent(0.2)
        tv.font = UIFont(name: CUSTOM_FONT, size: 18)
        tv.textColor = .black.withAlphaComponent(0.85)
        return tv
    }()
    
    var saveBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("저장하기", for: .normal)
        btn.setTitleColor(CUSTOM_SKYBLUE, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 18)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setuo
        
        print("debug : isNoteWithPhoto -> \(viewModel.isNoteWithPhoto)")
        print("debug : is new note -> \(viewModel.isNewNote)")
        setup()
        
        // 노트불러오기 인경우
        if(viewModel.isNewNote == false){
           // loadNoteData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // 화면터치시 키보드 내리기
        view.endEditing(true)
    }
    
    
    func setup(){
        view.backgroundColor = .white
        
        view.addSubview(hatView)
        hatView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        hatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        hatView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(titleTextField)
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        titleTextField.topAnchor.constraint(equalTo: hatView.bottomAnchor, constant: 40).isActive = true
        
        view.addSubview(dividerView)
        dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        dividerView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive  = true
        dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        
        view.addSubview(photoView)
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        photoView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 15).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: viewModel.isNoteWithPhoto ? 260 : 0).isActive = true
        
        view.addSubview(contextTextView)
        contextTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        contextTextView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 15).isActive = true
        contextTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive  = true
        contextTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        contextViewBottomLayoutConstraint  =  contextTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20)
        contextViewBottomLayoutConstraint?.isActive = true
        contextTextView.delegate = self
        
        // save btn
        let toolbar = UIToolbar()
        toolbar.backgroundColor =  .white
        toolbar.sizeToFit()
        let saveBarBtn = UIBarButtonItem.init(customView: saveBtn)
        let emptyBarBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // let addPhotoBarBtn
        toolbar.items = [emptyBarBtn, saveBarBtn]
        titleTextField.inputAccessoryView = toolbar
        contextTextView.inputAccessoryView = toolbar
    }
    
    
    
    func loadNoteData(){
        titleTextField.isUserInteractionEnabled = false
        contextTextView.isUserInteractionEnabled = false
//        addPhotoBtn.isHidden = true
        saveBtn.isHidden = true
    }
    
    //MARK: actions
    
    @objc func  didTapSave() {
        print("Debug : didTapPhoto")
    }

    @objc func handleKeyboardWillAppear(notification : NSNotification) {
        // 키보드가 올라갈때
        
        // print("debug :  notification -> \(notification)")

        
        if viewModel.isNoteWithPhoto {
            // 사진첨부 o -> view.origin.y, textvie
            
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                

                self.view.frame.origin.y -= 260
                
//                contextViewBottomLayoutConstraint?.isActive = false
//                contextViewBottomLayoutConstraint?.constant = -20
//                contextViewBottomLayoutConstraint?.isActive = true
            }
            
        }
        else{
            // 사진첨부 x -> textview, savebtn, addphotobtn
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                
               // self.view.frame.origin.y -= keyboardHeight
                
                contextViewBottomLayoutConstraint?.isActive = false
                contextViewBottomLayoutConstraint?.constant = -keyboardHeight-20
                contextViewBottomLayoutConstraint?.isActive = true
            }
        }
        
    }
    
    @objc func handleKeyboardWillHide(notification : Notification ){
        
        if viewModel.isNoteWithPhoto {
            // 사진첨부 o -> view.origin.y, textvie
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                

                self.view.frame.origin.y += 260
                
//                contextViewBottomLayoutConstraint?.isActive = false
//                contextViewBottomLayoutConstraint?.constant = -20
//                contextViewBottomLayoutConstraint?.isActive = true
            }
        }
        else{
            // 키보드가 내려갈때
            contextViewBottomLayoutConstraint?.isActive = false
            contextViewBottomLayoutConstraint?.constant = -20
            contextViewBottomLayoutConstraint?.isActive = true
        }
    }
}



extension NoteViewController : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        // origin.y -=

        // placeholder check
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // origin.y +=

        // placeholder check
    }

    func textViewDidChange(_ textView: UITextView) {
//
    }
}
