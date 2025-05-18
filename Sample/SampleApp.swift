//
//  SampleApp.swift
//  Sample
//
//  Created by Jeetesh Shaw on 06/05/25.
//

import SwiftUI
import FirebaseCore
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              if granted {
                  print("Notification authorization granted")
              } else {
                  print("Notification authorization denied")
              }
          }
          return true
    }
    

}

@main
struct SampleApp: App {
    @StateObject private var playerManager = AudioPlayerManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget to check your tasks!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)

        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            HomeView(isLongStory: true)
                .environmentObject(playerManager)
                .onAppear() {
                    scheduleNotification()
                }
        }
    }
}
