//
//  NotificationService.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 25/4/2024.
//

import Foundation
import UserNotifications

class NotificationService {
    var reminderApp = ReminderViewModel()
    var timer: Timer = Timer()
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.checkForPermission()
        })
    }
    
    func checkForPermission() {
        print("checking permission")
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }}
            default:
                return
            }}
    }
    
    func getRandomReminder() -> String {
        print("reminders", reminderApp.reminders)
        if !reminderApp.reminders.isEmpty {
            let reminder = reminderApp.reminders.randomElement()
            return reminder!.reminder
        }
        return "Default reminder"
    }
    
    func dispatchNotification() {
        print("in dispatch")
        let identifier = "reminder"
        let title = "Your reminder <3"
        let body = getRandomReminder()
        let hour = 18
        let minute = 5
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}
