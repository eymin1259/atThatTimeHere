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

    // 사진권한 체크
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
    
    // 앨범에서 사진고르는 imagePicker 실행
    func runPhotoLibrary(vc : BaseViewController) {
        DispatchQueue.main.async {
            
            let imagePickerController = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePickerController.modalPresentationStyle = .overFullScreen
                imagePickerController.allowsEditing = false
                vc.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    // 사진권한 없을시 권한설정 유도
    func goPhoneSetting(vc : BaseViewController){
        let alertController = UIAlertController(title :"Alert".localized(), message: "photo_permisson".localized(), preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "setting".localized(), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .default){ (_) -> Void in
        }
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
