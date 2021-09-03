//
//  MenuViewController.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import CoreLocation

class MenuViewController: BaseViewController {
    // 메뉴 : 추억쓰기, 내정보, 앱버전정보, 이용약관, 별점과리뷰작성, 로그아웃
    
    //MARK: properties
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
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
        startLocationUpdate()
        showLoading() // 위치정보를 가져올때까지 로딩
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        writeNoteLbl.isHidden = false
        settingLbl.isHidden = false
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
        print("Debug : location at MenuTab -> \(location)")
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
