//
//  AppDelegate.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/25/21.
//

import UIKit
import CoreLocation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 위치권한 설정
        locationManager.requestAlwaysAuthorization()
        
        // 알람권한 설정
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        center.requestAuthorization(options: authOptions) { isSuccess, error in
            if isSuccess {
                print("debug : requestAuthorization success")
            }
        }
        center.delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // foreground에 있을 때에도 push알림을 받게 하는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // 알람클릭시 호출되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 알람에 해당하는 노트 id
        let nid = response.notification.request.identifier
        // 노트의 index
        guard let idx = response.notification.request.content.userInfo["index"] as? String else {
            completionHandler()
            return
        }
        let noteDict : [String:String] = ["nid" : nid, "index" : idx]
    
        // notificaion 전송
        // maintabViewController 수신 -> selected tab = NoteListViewController
        //  NoteListViewController 수신 -> show note
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DID_RECEIVE_PUSH_ALARM) , object: nil, userInfo: noteDict)
        
        completionHandler()
      }
}
