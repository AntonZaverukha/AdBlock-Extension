//
//  SceneDelegate.swift
//  ContentBlocker
//
//  Created by Anton on 15.04.2023.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self

        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let instructionVC = storyboard.instantiateViewController(withIdentifier: "InstructionsVC")
            
            if let navigationController = window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(instructionVC, animated: true)
            } else {
                window?.rootViewController = instructionVC
                window?.makeKeyAndVisible()
            }
            
            completionHandler()
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        let content = UNMutableNotificationContent()
        content.title = "Special offer for you"
        content.body = "Best price! Only right now!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
        let request = UNNotificationRequest(identifier: "SpecialOfferNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let content = UNMutableNotificationContent()
        content.title = "Special offer for you"
        content.body = "Best price! Only right now!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "SpecialOfferNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }


}

