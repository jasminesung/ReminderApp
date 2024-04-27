//
//  ReminderDetail.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 27/4/2024.
//

import SwiftUI

struct ReminderDetail: View {
    @Binding var reminder : ReminderModel
    @ObservedObject var reminderApp = ReminderViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $reminder.reminder).font(.system(size: 20))
        }.padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        reminderApp.saveData(reminder: reminder)
                        reminder.reminder = ""
                    } label: {
                        Text("Save")
                    }

                }
            }
    }
}

#Preview {
    ReminderDetail(reminder: .constant(ReminderModel(reminder: "Yay")))
}
