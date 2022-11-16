//
//  MenuViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import CoreLocation
import UserNotifications

class MenuViewController: BaseViewController {
    // 메뉴 : 추억쓰기, 내정보, 앱버전정보, 이용약관, 별점과리뷰작성, 로그아웃
    
    //MARK: properties
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var viewModel = NoteListViewModel()

    //MARK: UI
    private var  writeNoteLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("writing_memories".localized(), for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(didTapWriteNote), for: .touchUpInside)
        return btn
    }()
    
    private var  settingLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("settings".localized(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapSetting), for: .touchUpInside)
        return btn
    }()

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewModel
        viewModel.disposebag = disposeBag
        viewModel.delegate = self

        // initial setting
        setupUI()
        
        //gps location setting
        locationManager.delegate = self
        locationManager.distanceFilter = RETURN_RANGE / 2
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.allowsBackgroundLocationUpdates = true // 백그라운드 설정
        
        //gps location update start
        startLocationUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        writeNoteLbl.isHidden = false
        settingLbl.isHidden = false
        
        // note list update
        viewModel.updateNoteList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // note list update
        viewModel.updateNoteList()
    }

    //MARK: methods
    func setupUI(){
        
        // customize navigationController backButton
        let backBtn = UIBarButtonItem(title: "back".localized(), style: .plain, target: self, action: nil)
        backBtn.tintColor = CUSTOM_MAIN_COLOR
        navigationItem.backBarButtonItem = backBtn
        
        // 스택뷰 생성 -> writeNoteLbl, settingLbl 포함
        let stackView = UIStackView(arrangedSubviews: [writeNoteLbl, settingLbl])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    // gps location update 시작
    func startLocationUpdate() {
        // 권환체크
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            // 권한없는경우
            case .notDetermined, .restricted, .denied:
                // 설정창으로 이동
                goLocationSetting()
            // 권한있는경우
            case .authorizedAlways, .authorizedWhenInUse:
                // showLoading() // 위치정보를 가져올때까지 로딩
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func goLocationSetting() {
        let alertController = UIAlertController(title :"Alert".localized(), message: "location_always_message".localized(), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "setting".localized(), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                // 설정창 이동
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Setting is opened: \(success)")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .default){ (_) -> Void in
        }
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // gps location update 중단
    func stopLocationUpdate(){
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: actions
    @objc func didTapWriteNote(){
        // 추억 쓰기 버튼 클릭
        let newNote = NoteViewController()
        newNote.viewModel.isNewNote = true // 새로운 노트 작성
        newNote.modalPresentationStyle = .pageSheet
        newNote.viewModel.isNoteWithPhoto = false
        newNote.delegate = self
        // location check
        if let location = currentLocation{
            newNote.viewModel.currentLocation = location
        }
        else {
            newNote.viewModel.currentLocation = nil
        }
        present(newNote, animated: true, completion: nil)
    }
    
    @objc func didTapSetting(){
        // 설정버튼 클릭
        writeNoteLbl.isHidden = true
        settingLbl.isHidden = true
        let setting  = SettingViewController()
        navigationController?.pushViewController(setting, animated: true)
    }
}

//MARK: extension NoteListViewModelDelegate
extension MenuViewController : NoteListViewModelDelegate {
    func didFindNoteToAlarm() {
        // 업데이트한 위치정보에서 씌여진 노트를 찾았으므로 위치정보 업데이트 일시중지
        stopLocationUpdate()
    }
    
    func didFinishMakeAlarm() {
        // 업데이트한 위치정보에서 씌여진 노트에 대해 알람 만들었으므로 다시 백그라운드 위치 업데이트 시작
        viewModel.updateNoteList()
        startLocationUpdate()
    }
}

//MARK: extension NoteViewControllerDelegate
extension MenuViewController : NoteViewControllerDelegate {
    func didSaveNote() {
        self.view.makeToast(
            "saved".localized()
            + "\n"
            + "saved_message".localized()
        )
        viewModel.updateNoteList()
    }
}

//MARK: extestion CLLocationManagerDelegate
extension MenuViewController : CLLocationManagerDelegate {
    //  gps 위치가 변경될 때마다 가장 최근 위치 데이터를 인자로 이 메서드가 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        writeNoteLbl.isEnabled = true
        
        // 위치정보
        guard let location = locations.first else {return}
        print("debug : didUpdateLocations -> \(location)")
        // 기존정보 삭제
        currentLocation = nil
        // 새로운 위치정보 저장
        currentLocation = location
        
        // 현재위치에서 씌여진 노트가 있는지 체크
        viewModel.checkNoteWroteAt(location: currentLocation)
    }
    
    //  gps위치정보를 가져올때 에러발생시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("debug : locationManager didFailWithError -> \(error.localizedDescription)")
        hideLoading()
        // 기존정보 삭제
        currentLocation = nil
        stopLocationUpdate()
    }
    
    // 앱의 위치 추적 허가 상태가 변경되면 이 메서드를 호출
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 허용안됨
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .notDetermined || manager.authorizationStatus == .restricted {
            hideLoading()
            stopLocationUpdate()
            // 기존정보 삭제
            currentLocation = nil
            self.view.makeToast("location_require".localized())
        }
        // 허용됨
        else if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            // 기존정보 삭제
            currentLocation = nil
            // 위치정보 재로드
            stopLocationUpdate()
            startLocationUpdate()
        }
    }
}
