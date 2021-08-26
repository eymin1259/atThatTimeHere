//
//  PhotoService.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import Photos
import MobileCoreServices

struct PhotoService {
    
    static let shared = PhotoService()

    private init () {
        print("debug : PhotoService shared init ")
    }

    
    func checkPhotoPermission(vc : BaseViewController) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            runPhotoLibrary(vc: vc)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    runPhotoLibrary(vc: vc)
                }
            })
        case .restricted:
            goPhoneSetting(vc: vc)
        case .denied:
            goPhoneSetting(vc: vc)
        default:
            goPhoneSetting(vc: vc)
        }
    }
    
    func runPhotoLibrary(vc : BaseViewController) {
        DispatchQueue.main.async {
            
            let imagePickerController = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePickerController.modalPresentationStyle = .overFullScreen
                imagePickerController.allowsEditing = true
                vc.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    func goPhoneSetting(vc : BaseViewController){
        let alertController = UIAlertController(title :"알림", message: "사진 등록을 위해 사진 접근권한이 필요합니다.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "설정", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "취소", style: .default){ (_) -> Void in
        }
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
