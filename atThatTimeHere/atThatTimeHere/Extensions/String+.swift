//
//  String+.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 11/16/22.
//

import Foundation

public extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
