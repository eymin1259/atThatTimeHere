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
    private lazy var  writeNoteLbl :  UIButton  =  {
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
        btn.setTitle("설정", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: CUSTOM_FONT, size: 25)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(didTapSetting), for: .touchUpInside)
        return btn
    }()

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // initial setting
        setupUI()
        
        //gps location update start
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true // 백그라운드 설정
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
        showLoading() // 위치정보를 가져올때까지 로딩
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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
        self.view.makeToast("노트를 저장했습니다.")
        viewModel.updateNoteList()
    }
}

extension MenuViewController : CLLocationManagerDelegate {
    //  gps 위치가 변경될 때마다 가장 최근 위치 데이터를 인자로 이 메서드가 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        hideLoading()
        // 위치정보
        guard let location = locations.first else {return}
        // 기존정보 삭제
        currentLocation = nil
        // 새로운 위치정보 저장
        currentLocation = location
        
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        
        
        print("Debug : note list count -> \(viewModel.noteList.count)")
        print("Debug : location at MenuTab -> \(location.coordinate)")
        viewModel.noteList.forEach { noteItem in
            
            
            if let noteLatitude = Double(noteItem.latitude), let noteLongitude = Double(noteItem.longitude), let distance = currentLocation?.distance(from: CLLocation(latitude: noteLatitude, longitude: noteLongitude)), distance <= RETURN_RANGE, let lastAlarmDate = formatter.date(from: noteItem.lastAlarmDate), let writeDate = formatter.date(from:noteItem.writeDate) {
                // 해당지역 RETURN_RANGE(돌아옴인식범위,200m) 이내로 다시방문한 경우
                // distance : 노트쓴 장소와 현재 위치 거리차이
                // lastAlarmDate : 마지막 알람 보낸 날짜
                // writeDate : 노트 작성 날짜

                
                let intervalDay = lastAlarmDate.timeIntervalSinceNow / 86400 * -1 // 오늘와 마지막알람날짜 시간차이
                let alaramCheck = noteItem.onOffAlarm // 해당 노트 알람 on/off 차이
                if intervalDay >= REMINDE_INTERVAL_DAY, alaramCheck == ALARM_ON {
                    // 알람on, REMINDE_INTERVAL_DAY(알람간격,31일)이상이면 -> 알람 보내기
                    
                    stopLocationUpdate()
                    let todayStr = formatter.string(from: Date()) // 오늘날짜
                    let writeDateIntervalDay = writeDate.timeIntervalSinceNow / 86400 * -1 // 노트쓴 날짜로부터 오늘날짜 시간차이
                    
                    // db에 알람 전송날짜를 오늘로 갱신
                    DBService.shared.updateLastAlarmDate(withNoteId: "\(noteItem.id)", newLastAlarmDate: todayStr) { updadateResult in
                        if updadateResult { // 갱신성공시
                            
                            // 알람 보내기
                            print("Debug : send notification")
                            
                            // 알람메세지
                            let content = UNMutableNotificationContent()
                            content.title = noteItem.title
                            content.body = "\(Int(writeDateIntervalDay))일전 지금 이곳에서 작성한 노트입니다."
                            content.badge = 1
                            
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
                        }
                    }
                }
            }
        }
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
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .notDetermined || manager.authorizationStatus == .restricted {
            hideLoading()
            stopLocationUpdate()
            // 기존정보 삭제
            currentLocation = nil
            self.view.makeToast("위치정보 권한이 필요합니다.")
        }
    }
}
