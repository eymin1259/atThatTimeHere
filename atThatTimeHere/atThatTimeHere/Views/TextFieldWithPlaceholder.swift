//
//  TextFieldWithPlaceholder.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

class TextFieldWithPlaceholder: UITextField {

    init(placeholder: String, fontSize : Float = 15){
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spacer.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftView = spacer
        leftViewMode = .always
        borderStyle = .none
        textColor = .black
        font = UIFont(name: CUSTOM_FONT, size: CGFloat(fontSize))
        keyboardAppearance = .default
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 1, alpha: 0.1) // make tf transparent
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor:UIColor(white: 0, alpha: 0.35)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
