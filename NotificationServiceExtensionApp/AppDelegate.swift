//
//  AppDelegate.swift
//  NotificationServiceExtensionApp
//
//  Created by BaglaiB on 25.04.2020.
//  Copyright © 2020 bogdan. All rights reserved.
//

import UIKit
import SimulatorRemoteNotifications
import TestNotificationServiceExtension

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.configureUserNotification()
        application.registerForRemoteNotifications()
        application.listenForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken: \(deviceToken.description)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        if let body = userInfo["body"] as? Int  {
            let date = dateFormatter.string(from: Date())
            let notificationString = "\(date) - body:\(body * 2)"

            self.save(string: notificationString)
            self.addToTableData(string: notificationString)
        }

        if let message = userInfo["message"] as? String  {
            let date = dateFormatter.string(from: Date())
            let notificationString = "\(date) - \(message)"

            self.save(string: notificationString)
            self.addToTableData(string: notificationString)

            self.presentLocalMessageNotification(message: message)
        }
    }

    fileprivate func save(string: String) {
        let defaults = UserDefaults.standard
        var savedArray = defaults.object(forKey: "PushNotifications") as? [String] ?? [String]()
        savedArray.append(string)
        defaults.set(savedArray, forKey: "PushNotifications")
    }

    fileprivate func addToTableData(string: String) {
        guard let tableViewController = UIApplication.shared.windows[1].rootViewController as? TableViewController else {
            return
        }
        tableViewController.tableViewModel.cellVMs.append(string)
        tableViewController.tableView.reloadData()
    }

    private func configureUserNotification() {
        UNUserNotificationCenter.current().delegate = self

        let startAction = UNNotificationAction(identifier: "Open", title: "See message", options: .foreground)
        let dismissAction = UNNotificationAction(identifier: "Dismiss", title: "Dismiss", options: [])

        let category = UNNotificationCategory(identifier: "UNidentifier",
                                              actions: [startAction, dismissAction],
                                              intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error ) in
            if granted {
                print("authorization granted")
            } else {
                print("authorization not granted")
            }
        }
    }

    func presentLocalMessageNotification(message: String) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "New message"
        content.body = message
        content.badge = 1
        content.categoryIdentifier = "UNidentifier"
        content.userInfo = ["message":"scheduleLocal"]
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "UNidentifier", content: content, trigger: trigger)
        center.add(request) { (error) in
            print("scheduleLocal error: \(error.debugDescription)")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("notification: \(notification)")
        completionHandler([.badge, .sound, .alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier

        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print("UNNotificationDismissActionIdentifier")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("UNNotificationDefaultActionIdentifier")
            completionHandler()
        default:
            print("UNNotification default")
            completionHandler()
        }
    }
}
