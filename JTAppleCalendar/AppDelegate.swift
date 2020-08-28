//
//  AppDelegate.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/10.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIViewControllerTransitioningDelegate {

    var window: UIWindow?
    var notiCount: Int = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
        })
        Realm.Configuration.defaultConfiguration = config
        
        UNUserNotificationCenter.current().requestAuthorization(
               options: [.alert, .sound, .badge]){
                   (granted, _) in
                   if granted{
                       UNUserNotificationCenter.current().delegate = self
                }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
// 通知を受け取ったときの処理
extension AppDelegate: UNUserNotificationCenterDelegate {
    //when iPhone was locked or the app was closed...
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if  let planDetailVC = storyboard.instantiateViewController(withIdentifier: "pdVC") as? PlanDetailViewController,
                let tabBarController = rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController,
                notiCount == 0 {
                navController.pushViewController(planDetailVC, animated: true)
                print("before1: \(notiCount)")
                notiCount = 1
                print("after1: \(notiCount)")
            }else if let tabBarController = rootViewController as? UITabBarController,
            let navController = tabBarController.selectedViewController as? UINavigationController{
                navController.popViewController(animated: true)
                notiCount = 0
            }
        }
        completionHandler()
    }
}
