//
//  HomeView.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 16/4/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authService = AuthenticationService()
    @ObservedObject var reminderApp = ReminderViewModel()
    @State var reminder = ReminderModel(reminder: "")
    @State var currentReminder = ReminderModel(reminder: "")
    
    func checkForPermission() {
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

    
    func dispatchNotification() {
        print("in dispatch")
        let identifier = "reminder"
        let title = "Your reminder <3"
        let body = self.currentReminder.reminder
        let hour = 18
        let minute = 23
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
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    var body: some View {
        VStack {
            Button {
                authService.logOut()
            } label: {
                Text("Log Out")
            }
            NavigationStack {
                List {
                    ForEach($reminderApp.reminders) {
                        $reminder in NavigationLink {
                            ReminderDetail(reminder: $reminder)
                        } label: {
                            Text(reminder.reminder)
                        }
                    }
                    Section {
                        NavigationLink {
                            ReminderDetail(reminder: $reminder)
                        } label: {
                            Text("New reminder")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                        }
                    }
                }
            }
            .onAppear {
                reminderApp.fetchData()
            }
            .refreshable {
                reminderApp.fetchData()
            }
            .onReceive(reminderApp.$currentReminder, perform: {
                newVal in self.currentReminder = newVal;
                checkForPermission();
            })
        }
    }
}

#Preview {
    HomeView()
}
