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
    var emojis = ["☀️", "🌸", "🩵", "🌈", "🍀"]
    var colors = [Color.pink, Color.indigo, Color.teal, Color.mint]
    
    
    func getRandomEmoji() -> String {
        return emojis.randomElement()!
    }
    
    func getRandomColor() -> Color {
        return colors.randomElement()!
    }
    
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
    
    func deleteReminder(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let reminderId = reminderApp.reminders[index].id
        Task {
            await reminderApp.deleteData(id: reminderId!)
        }
    }

    
    func dispatchNotification() {
        let title = "Your reminder❤️"
        let body = self.currentReminder.reminder
        let hour = 15
        let minute = 0
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
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.removeAllPendingNotificationRequests()
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
                            Text(getRandomEmoji() + " " + reminder.reminder).foregroundColor(getRandomColor())
                        }
                    }.onDelete(perform: deleteReminder)
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
