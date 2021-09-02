//
//  PickerPhotoView.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/31/21.
//

import UIKit

class PickerPhotoView: UIView {
    
    // 사진이미지
    private var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = false
        imgView.backgroundColor = .lightGray
        return imgView
    }()
    
    // 뒤로가기 버튼 -> PickerPhotoView 숨기기
    var closeBtn : UIButton = {
        var btn = UIButton()
        btn.setTitle("<  뒤로", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 20)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        guard let superView = superview else {return}
        
        widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: superView.heightAnchor).isActive = true
        
        addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        closeBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
    }
    
    func setImage(image : UIImage){
        imageView.image = image
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 150).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    // PickerPhotoView 숨기기
    @objc func didTapClose() {
        isHidden = true
    }

}
