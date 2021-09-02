//
//  BaseViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import JGProgressHUD
import Toast_Swift

class BaseViewController: UIViewController {
    
    //MARK: UI
    lazy var hud: JGProgressHUD = {
        let loader = JGProgressHUD(style: .dark)
        return loader
    }()
    
    //MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("debug : BaseViewController viewDidLoad")
    }
    
    //MARK: methods
    func showLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view, animated: true)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss(animated: true)
        }
    }
    
    func showDialog(title: String, message :String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title :title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (_) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
