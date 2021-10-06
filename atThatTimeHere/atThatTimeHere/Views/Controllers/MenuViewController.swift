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
        btn.setTitle("추억 쓰기", for: .normal)
        btn.setTitleColor(CUSTOM_MAIN_COLOR, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapWriteNote), for: .touchUpInside)
        return btn
    }()
    
    private var  settingLbl :  UIButton  =  {
        let btn = UIButton(type: .system)
        btn.setTitle("앱 설정", for: .normal)
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
        let backBtn = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
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
        let alertController = UIAlertController(title :"알림", message: "추억이 어느 장소에서 저장됬는지 알 수 있도록 위치권한을 항상으로 설정해주세요.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정", style: .default) { (_) -> Void in
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
        let cancelAction = UIAlertAction(title: "취소", style: .default){ (_) -> Void in
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

//MARK: extension NoteViewControllerDelegate
extension MenuViewController : NoteViewControllerDelegate {
    func didSaveNote() {
        self.view.makeToast("저장되었습니다.\n지금 작성된 추억은 훗날 이곳으로 다시 돌아왔을 때 보여드릴께요!")
        viewModel.updateNoteList()
    }
}

extension MenuViewController : CLLocationManagerDelegate {
    //  gps 위치가 변경될 때마다 가장 최근 위치 데이터를 인자로 이 메서드가 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // hideLoading()
        // 위치정보
        guard let location = locations.first else {return}
        print("debug : didUpdateLocations -> \(location)")
        // 기존정보 삭제
        currentLocation = nil
        // 새로운 위치정보 저장
        currentLocation = location
  
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")

        // 노트들 하나씩 체크
        for (idx, noteItem) in viewModel.noteList.enumerated() {
        
            // 노트 삭제 여부 확인
            let noteDeleted = noteItem.deleted
            if noteDeleted == 0 {
                
                if let noteLatitude = Double(noteItem.latitude), let noteLongitude = Double(noteItem.longitude), let distance = currentLocation?.distance(from: CLLocation(latitude: noteLatitude, longitude: noteLongitude)), distance <= RETURN_RANGE, let lastAlarmDate = formatter.date(from: noteItem.lastAlarmDate), let writeDate = formatter.date(from:noteItem.writeDate){
                    // 해당지역 RETURN_RANGE(돌아옴인식범위,200m) 이내로 다시방문한 경우
                    // distance : 노트쓴 장소와 현재 위치 거리차이
                    // lastAlarmDate : 마지막 알람 보낸 날짜
                    // writeDate : 노트 작성 날짜

                    
                    let intervalDay = lastAlarmDate.timeIntervalSinceNow / 86400 * -1 // 오늘과 마지막알람날짜 시간차이
                    let alaramCheck = noteItem.onOffAlarm // 해당 노트 알람 on/off 체크
                    
                    if intervalDay >= REMINDE_INTERVAL_DAY, alaramCheck == ALARM_ON {
                        // 알람on, REMINDE_INTERVAL_DAY(알람간격시간이 지났으면) -> 알람 보내기
                        
                        // 업데이트 일시정지
                        stopLocationUpdate()
                        
                        let todayStr = formatter.string(from: Date()) // 오늘날짜
                        let writeDateIntervalDay = writeDate.timeIntervalSinceNow / 86400 * -1 // 노트쓴 날짜로부터 오늘날짜 시간차이
                        
                        // db에 알람 전송날짜를 오늘로 갱신
                        NoteService.shared.updateLastAlarmDateRX(withNoteId: "\(noteItem.id)", newLastAlarmDate: todayStr)
                            .subscribe(onNext: { _ in // 갱신성공시
                                // 알람 보내기
                                print("Debug : send notification -> note : \(noteItem.id)")
                                
                                // 알람메세지
                                let content = UNMutableNotificationContent()
                                content.title = noteItem.title
                                content.body = "\(Int(writeDateIntervalDay))일전 그때 이곳에서 작성한 노트입니다."
                                content.badge = 1
                                content.sound = .default
                                let indexDict : [String:String] = ["index" : "\(idx)"]
                                content.userInfo = indexDict
                                
                                // 알람 전송
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                let req = UNNotificationRequest(identifier: "\(noteItem.id)", content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(req) { err in
                                    DispatchQueue.main.async { [weak self]  in
                                        guard let weakSelf = self else {return }
                                        if let error = err {
                                            // 전송실패
                                            print("debug : UNUserNotificationCenter  error -> \(error.localizedDescription)")
                                            weakSelf.viewModel.updateNoteList()
                                            weakSelf.startLocationUpdate()
                                        }
                                        else{
                                            // 전송성공
                                            weakSelf.viewModel.updateNoteList()
                                            weakSelf.startLocationUpdate()
                                        }
                                    }
                                }
                            }).disposed(by: disposeBag)
                    }
                }
            }
        } //  end for (idx, noteItem) in viewModel.noteList.enumerated()
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
            self.view.makeToast("위치권한이 필요합니다.")
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
