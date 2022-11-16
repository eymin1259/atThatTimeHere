//
//  NoteViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import CoreLocation

@objc protocol NoteViewControllerDelegate {
    @objc  optional func didSaveNote() // 노트저장성공을 알림
    @objc optional func didRemoveNote() // 노트 삭제를 알림
    @objc optional func didEditNote() // 노트 수정 알림
}

class NoteViewController: BaseViewController {
    
    //MARK: properties
    var viewModel = NoteViewModel()
    var contentViewBottomLayoutConstraint : NSLayoutConstraint?
    var delegate : NoteViewControllerDelegate?
    
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
    
    // 제목 입력
    var titleTextField : TextFieldWithPlaceholder = {
        var tf = TextFieldWithPlaceholder(placeholder: "title".localized(), fontSize: 30)
        tf.keyboardType = .default
        tf.autocorrectionType = .no
        return tf
    }()
    
    // 노트에 등록된 사진
    var photoView : UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    // 본문내용
    var contentTextView : UITextView = {
        var tv = UITextView()
        tv.keyboardType = .default
        tv.autocorrectionType = .no
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: CUSTOM_FONT, size: 18)
        tv.textColor = .gray
        tv.text = ""
//        tv.backgroundColor = .green.withAlphaComponent(0.2)
        return tv
    }()
    
    // 본문내용 placeholer
    var contentPlaceHolder : UILabel = {
        var lbl  = UILabel()
        lbl.text = "content".localized()
        lbl.font = UIFont(name: CUSTOM_FONT, size: 18)
        lbl.textColor = .gray.withAlphaComponent(0.6)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // 수정 시작버튼
    var editBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("edit".localized(), for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapEditStartBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 수정 완료 버튼
    var confirmEditBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("confirm".localized(), for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 18)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapConfirmEditBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 사진첨부 버튼
    var photoBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("photo".localized(), for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 18)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapPhotoBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 저장 버튼
    var saveBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("save".localized(), for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 18)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapSaveBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 이미지픽커에서 고른 사진
    var pickerPhotoView  = PickerPhotoView()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setuo
        print("debug : isNoteWithPhoto -> \(viewModel.isNoteWithPhoto)")
        print("debug : is new note -> \(viewModel.isNewNote)")
        setup() // ui setting
        
        // 노트불러오기인경우
        if(viewModel.isNewNote == false){
            
            // 수정 불가능 처리
            titleTextField.isUserInteractionEnabled = false
            contentTextView.isUserInteractionEnabled = false
            contentPlaceHolder.isHidden = true
            
            // 불러올 노트정보 load
            loadNoteData()
        }
        else{  // 노트쓰기인 경우
            titleTextField.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // keyboardWillShowNotification -> 키보느 높이에 맞춰 본문내용 textfield 높이 조절
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // keyboardWillShowNotification -> 키보느 높이에 맞춰 본문내용 textfield 높이 조절
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: methods
    
    // 화면터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    // ui setup 함수
    func setup(){
        view.backgroundColor = .white
        
        view.addSubview(hatView)
        hatView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        hatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        hatView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        // 제목
        view.addSubview(titleTextField)
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        titleTextField.topAnchor.constraint(equalTo: hatView.bottomAnchor, constant: 40).isActive = true
        
        // 구분선
        view.addSubview(dividerView)
        dividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        dividerView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive  = true
        dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        
        // 사진
        view.addSubview(photoView)
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        photoView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 15).isActive = true
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive  = true
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: viewModel.isNoteWithPhoto ? 400 : 0).isActive = true
        
        // 본문내용
        view.addSubview(contentTextView)
        contentTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive =  true
        contentTextView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 15).isActive = true
        contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive  = true
        contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        contentViewBottomLayoutConstraint  =  contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -60)
        contentViewBottomLayoutConstraint?.isActive = true
        contentTextView.delegate = self // 본문내용 placeholder -> UITextViewDelegate
        contentTextView.layoutManager.delegate = self // 본문내용 줄간격 -> NSLayoutManagerDelegate
        
        // 본문내용 placeholder
        view.addSubview(contentPlaceHolder)
        contentPlaceHolder.topAnchor.constraint(equalTo: contentTextView.topAnchor).isActive = true
        contentPlaceHolder.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor).isActive  = true
        contentPlaceHolder.isHidden = viewModel.isNewNote ? false : true
        
        // 사진버튼, 저장버튼은 키보드의 toolbar로 세팅
        let toolbar = UIToolbar()
        toolbar.backgroundColor =  .white
        toolbar.sizeToFit()
        let photoBarBtn = UIBarButtonItem.init(customView: photoBtn)
        let saveBarBtn = UIBarButtonItem.init(customView: saveBtn)
        let emptyBarBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [photoBarBtn, emptyBarBtn, saveBarBtn]
        titleTextField.inputAccessoryView = toolbar
        contentTextView.inputAccessoryView = toolbar
    
        // 수정버튼
        view.addSubview(editBtn)
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        editBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        editBtn.isHidden = viewModel.isNewNote ? true : false
        
        // 이미지피커로 고른 사진을 보여줄 view
        view.addSubview(pickerPhotoView)
        pickerPhotoView.setup()
        pickerPhotoView.isHidden = true
        
        
    }
    
    // 노트불러오기인경우 노트정보 load
    func loadNoteData(){        
        viewModel.readNote()
            .subscribe(onNext: { note in
                print("debug : read  note -> \(note)")
                // 뷰 바인딩 : 제목, 내용
                self.titleTextField.text = note.title
                self.contentTextView.text = note.content
                // 노트이미지-뷰 바인딩
                if  let imageUrl = URL(string: note.imagePath) {
                    do {
                        let imageData = try Data(contentsOf: imageUrl)
                        self.photoView.image =  UIImage(data: imageData)
                    } catch {
                        print("Error loading image : \(error)")
                        self.view.makeToast("no_photo".localized())
                        return
                    }
                }
            }, onError: {error in
                self.view.makeToast("no_note".localized())
            }).disposed(by: disposeBag)
    }
    
    func showPhotoAlert()  {
        let alertController = UIAlertController(title :"photo".localized(), message: "", preferredStyle: .actionSheet)
        
        let selectPhoto = UIAlertAction(title: "select_photo".localized(), style: .default) { (_) -> Void in
            self.showLoading()
            // 권환확인 및 image picker 실행
            PhotoService.shared.checkPhotoPermission(vc: self)
        }
        let showSelectedPhoto = UIAlertAction(title: "show_photo".localized(), style: .default) { (_) -> Void in
            self.view.endEditing(true)
            // pickerPhotoView 세팅
            if let noteImg = self.viewModel.noteImage {
                self.pickerPhotoView.setImage(image: noteImg)
                self.pickerPhotoView.isHidden = false
            }
            else {
                self.viewModel.noteImageUrl = nil
                self.viewModel.noteImage = nil
                self.viewModel.isNoteWithPhoto = false
                self.view.makeToast("no_photo".localized())
            }
        }
        let removePhoto = UIAlertAction(title: "remove_photo".localized(), style: .destructive) { (_) -> Void in
            // 선택한 데이터 초기화
            self.viewModel.noteImageUrl = nil
            self.viewModel.noteImage = nil
            self.viewModel.isNoteWithPhoto = false
        }
        let cancle = UIAlertAction(title: "cancel".localized(), style: .cancel){ (_) -> Void in
        }
        
        if viewModel.isNoteWithPhoto {
            // 첨부된 사진 있는경우
            alertController.addAction(showSelectedPhoto) // 사진보기
            alertController.addAction(removePhoto) // 첨부취소
        }
        else {
            // 첨부된 사진 없는경우
            alertController.addAction(selectPhoto) // 사진선택
        }
        alertController.addAction(cancle)
        present(alertController, animated: true, completion: nil)
    }
    
    func showNoteEditAlert(){
        let alertController = UIAlertController(title :"edit".localized(), message: "", preferredStyle: .actionSheet)
        
        let editNote = UIAlertAction(title: "edit".localized(), style: .default) { (_) -> Void in
            // 글, 내용 수정
            guard let _ = self.viewModel.noteId else {
                self.view.makeToast("unable_edit".localized())
                return
            }
            // edit mode 로 전환
            self.titleTextField.isUserInteractionEnabled = true
            self.contentTextView.isUserInteractionEnabled = true
            self.contentPlaceHolder.isHidden = true
            self.photoView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
            // 사진버튼, 수정완료버튼은 키보드의 toolbar로 세팅
            let toolbar = UIToolbar()
            toolbar.backgroundColor =  .white
            toolbar.sizeToFit()
            let photoBarBtn = UIBarButtonItem.init(customView: self.photoBtn)
            let confirmEditBarBtn = UIBarButtonItem.init(customView: self.confirmEditBtn)
            let emptyBarBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [photoBarBtn, emptyBarBtn, confirmEditBarBtn]
            self.titleTextField.inputAccessoryView = toolbar
            self.contentTextView.inputAccessoryView = toolbar
            self.titleTextField.becomeFirstResponder()
        }
        
        let removeNote = UIAlertAction(title: "remove_memory".localized(), style: .destructive ) { (_) -> Void in
            // 추억노트 지우기            
            self.viewModel.deleteNote()
                .subscribe(onNext: { _ in
                    self.delegate?.didRemoveNote?() // note list update
                    self.dismiss(animated: true, completion: nil) // dismiss noteVC
                }, onError: {error in
                    print("Debug : note remove error -> \(error.localizedDescription)")
                    self.view.makeToast("unable_remove".localized())
                }).disposed(by: self.disposeBag)
        }
        
        let cancle = UIAlertAction(title: "cancel".localized(), style: .cancel){ (_) -> Void in
        }
        
        alertController.addAction(editNote)
        alertController.addAction(removeNote)
        alertController.addAction(cancle)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: actions
    @objc func handleKeyboardWillAppear(notification : NSNotification) {
        // 키보드가 올라갈때
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            contentViewBottomLayoutConstraint?.isActive = false
            contentViewBottomLayoutConstraint?.constant = -keyboardHeight
            contentViewBottomLayoutConstraint?.isActive = true
        }
    }
    
    @objc func handleKeyboardWillHide(notification : Notification ){
        // 키보드가 내려갈때
        contentViewBottomLayoutConstraint?.isActive = false
        contentViewBottomLayoutConstraint?.constant = -60
        contentViewBottomLayoutConstraint?.isActive = true
    }
    
    // 사진첨부버튼 클릭 action
    @objc func  didTapPhotoBtn(){
        showPhotoAlert()
    }
    // 수정시작버튼 클릭
    @objc func didTapEditStartBtn() {
        showNoteEditAlert()
    }
    
    // 수정완료버튼 클릭
    @objc func didTapConfirmEditBtn() {
        showLoading()
        
        // 수정정보
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        
        // 업데이트
        viewModel.updateNote(title: title, content: content)
            .subscribe(onNext: { _ in
                // update 성공
                self.hideLoading()
                self.view.endEditing(true)
                self.delegate?.didEditNote?()
                self.dismiss(animated: true, completion: nil)
            }, onError: { error in
                // update 실패
                self.hideLoading()
                self.view.endEditing(true)
                self.view.makeToast("unable_edit".localized())
            }).disposed(by: self.disposeBag)
    }
    
    // 저장버튼 클릭 action
    @objc func  didTapSaveBtn() {
        // 노트저장(유저아이디, 제목,내용, 이미지파일패스, 시간)
        showLoading()

        // 현재 로그인한 유저아이디
        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] as? String else {
            self.view.makeToast("no_login_info".localized())
            return
        }
        
        // 제목, 내용
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        
        // 저장
        viewModel.createNote(userId: uid, title: title, content: content)
            .subscribe(onNext: {_ in
                // insert 성공
                self.hideLoading()
                self.view.endEditing(true)
                self.delegate?.didSaveNote?()
                self.dismiss(animated: true, completion: nil)
            }, onError: { error in
                // insert 실패
                self.hideLoading()
                self.view.endEditing(true)
                self.view.makeToast("unable_save".localized())
            }).disposed(by: disposeBag)
    }
}

// MARK: extension : UIImagePickerControllerDelegate
extension NoteViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진 선택 취소
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.hideLoading()
        if viewModel.noteImage == nil || viewModel.noteImageUrl == nil {
            viewModel.noteImage = nil
            viewModel.noteImageUrl = nil
            viewModel.isNoteWithPhoto = false
        }
        else {
            viewModel.isNoteWithPhoto = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 사진 선택 완료
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 이미지정보 추출 : image data, image url
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            // 이미지 정보 저장
            viewModel.noteImageUrl = imageUrl
            viewModel.noteImage = originalImage
            // 완료 이후 ui 처리
            self.hideLoading()
            self.viewModel.isNoteWithPhoto = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: extension : UITextViewDelegate
extension NoteViewController : UITextViewDelegate, NSLayoutManagerDelegate {
    // 본문내용 placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 본문내용 입력 시작시 비어있던 상태면
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = ""
            contentPlaceHolder.isHidden = true // 플레이스홀더 보여주기
        }
    }
    // 본문내용 placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        // 본문내용 입력 종료시 비어있던 상태면
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = ""
            contentPlaceHolder.isHidden = false // 플레이스홀더 숨기기
        }
    }
    // 줄간격
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 10
    }
}
