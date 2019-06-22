//
//  AppDelegate.swift
//  AlertMemoApp2
//
//  Created by Yuta Matsuo on 2018/12/21.
//  Copyright © 2018 ym9mmApp. All rights reserved.
//

import UIKit
//必須
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    //配列保持
    var contentsData:[String] = []
    var timesData:[Int] = []
    var timesLabel:[String] = []
    
    //ID保持
    var iDs:[String] = []
    //日時保持
    var dates:[Date] = []
    //UserDefaultsのインスタンス
    var userDefaults = UserDefaults.standard
    //データリセット(デバッグ用)
    func resetDatas(){
        //////削除///////
 
            // 通知の削除
            let center = UNUserNotificationCenter.current()
        for i in 0..<iDs.count {
            center.removePendingNotificationRequests(withIdentifiers: [iDs[i]])
         }
        
        contentsData.removeAll()
        timesData.removeAll()
        iDs.removeAll()
        dates.removeAll()
        timesLabel.removeAll()
        
        self.userDefaults.removeObject(forKey: "contentsDataBefore")
        self.userDefaults.removeObject(forKey: "timesDataBefore")
        self.userDefaults.removeObject(forKey: "iDs")
        self.userDefaults.removeObject(forKey: "dates")
        self.userDefaults.removeObject(forKey: "timesLabel")
  
        userDefaults.register(defaults:["contentsDataBefore": [String]()])
        userDefaults.register(defaults:["timesDataBefore": [String]()])
        userDefaults.register(defaults:["iDs": [String]()])
        userDefaults.register(defaults:["dates": [Date]()])
        userDefaults.register(defaults:["timesLabel": [String]()])
        
        appendContents()
 
    }

    
//アプリ起動時に呼ばれる
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
        //通知の許可をリクエスト
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge,.sound]){
            (granted,error) in
            if granted{
                print("許可")
            }
            else{
                print("許可しない")
            }
            
            UNUserNotificationCenter.current().delegate = self
        }
        
       // resetDatas()
        
        
        //永続化処理、すでにつくられているか場合分け
        //存在チェック
        if userDefaults.object(forKey:"iDs") != nil{
            iDs = userDefaults.array(forKey: "iDs") as! [String]
        }
        else{
            userDefaults.register(defaults:["iDs": [String]()])
        }
        
        if userDefaults.object(forKey:"contentsDataBefore") != nil{
            contentsData = userDefaults.array(forKey: "contentsDataBefore") as! [String]
            
        }
        else{
            userDefaults.register(defaults:["contentsDataBefore": [String]()])
            
        }
        if userDefaults.object(forKey:"timesDataBefore") != nil{
            timesData = userDefaults.array(forKey: "timesDataBefore") as! [Int]
            
        }
        else{
            userDefaults.register(defaults:["timesDataBefore": [String]()])
            
        }
        if userDefaults.object(forKey:"dates") != nil{
            dates = userDefaults.array(forKey: "dates") as! [Date]
        }
        else{
            userDefaults.register(defaults:["dates": [Date]()])
        }
        if userDefaults.object(forKey:"timesLabel") != nil{
            timesLabel = userDefaults.array(forKey: "timesLabel") as! [String]
        }
        else{
            userDefaults.register(defaults:["timesLabel": [String]()])
        }
        
        return true
    }
    
       //永続化保存処理
    func appendContents(){
        //userDefaultsに保持
        userDefaults.set(iDs,forKey:"iDs")
        userDefaults.set(contentsData,forKey:"contentsDataBefore")
        userDefaults.set(timesData, forKey: "timesDataBefore")
        userDefaults.set(dates, forKey: "dates")
        userDefaults.set(timesLabel, forKey: "timesLabel")
        
    }
    
    //フォアグラウンドで通知受信処理
    @available(iOS 10.0,*)
    func userNotificationCenter(_ center:UNUserNotificationCenter,willPresent notification:UNNotification,withCompletionHandler comletionHandler:(UNNotificationPresentationOptions) -> Void){
        //通知を行う
       comletionHandler([.badge,.sound,.alert])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}


