//
//  TextFieldWithPlaceholder.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit

class TextFieldWithPlaceholder: UITextField {

    init(placeholder: String){
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spacer.widthAnchor.constraint(equalToConstant: 10).isActive = true
        leftView = spacer
        leftViewMode = .always
        borderStyle = .none
        textColor = .black
        keyboardAppearance = .default
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 1, alpha: 0.1) // make tf tranparent
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor:UIColor(white: 0, alpha: 0.35)])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
