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
    
    //MARK: UI
    var hatView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 3).isActive  = true
        view.layer.cornerRadius = 2
        return view
    }()
    var dividerView = DividerView()
    
    var titleTextField : TextFieldWithPlaceholder = {
        var tf = TextFieldWithPlaceholder(placeholder: "제목", fontSize: 30)
        tf.keyboardType = .default
        return tf
    }()
    
    lazy var photoView : PhotoView = {
       var view = PhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
//    var contextTextField : TextFieldWithPlaceholder = {
//        var tf = TextFieldWithPlaceholder(placeholder: "내용", fontSize: 15, heightSize: 100)
//        tf.keyboardType = .default
//        // tf.heightAnchor.constraint(greaterThanOrEqualTo: 100).isActive = true
//        // tf.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive =  true
//         tf.backgroundColor = .orange.withAlphaComponent(0.2)
////        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardWillAppear))
////        tf.addGestureRecognizer(gesture)
//        tf.addTarget(self, action: #selector(handleKeyboardWillAppear), for: .editingDidBegin)
//
//
//        return tf
//    }()
    var contextTextView : UITextView = {
       var tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .orange.withAlphaComponent(0.2)
        
        
        return tv
    }()
    
    // var addPhotoBtn
    
    //    var saveBtn
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setuo
        setup()
        
        // 노트불러오기 인경우
        if(viewModel.isNewNote == false){
            loadNoteData()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//       // NotificationCenter.default.addObserver(contextTextField, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
////        NotificationCenter.default.removeObserver(contextTextField,name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(contextTextField,name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
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
        dividerView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive  = true
        dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40).isActive = true
        
        view.addSubview(photoView)
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        photoView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 30).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        
        view.addSubview(contextTextView)
        contextTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        contextTextView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 20).isActive = true
        contextTextView.widthAnchor.constraint(equalToConstant:  320).isActive = true
        contextTextView.delegate = self
    }
    
    func loadNoteData(){
        titleTextField.isUserInteractionEnabled = false  //  read-only title
    }
    
    //MARK: actions
    @objc func didTapPhoto(sender:Any){
        print("Debug : didTapPhoto")
         PhotoService.shared.checkPhotoPermission(vc: self)
        
    }
    
//    @objc func handleKeyboardWillAppear(notification : Notification) {
//        // 키보드가 올라갈때
//
//        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            self.view.frame.origin.y -= keyboardHeight
//            viewModel.isEditiing = true
//        }
//    }
//
//    @objc func handleKeyboardWillHide(notification : Notification ){
//        // 키보드가 내려갈때
//        if viewModel.isEditiing == true {
//            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                let keyboardHeight = keyboardFrame.cgRectValue.height
//                self.view.frame.origin.y += keyboardHeight
//                viewModel.isEditiing = false
//            }
//
//        }
//
//    }
    
    
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
}
