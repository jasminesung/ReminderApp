//
//  ReminderViewModel.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 27/4/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor class ReminderViewModel : ObservableObject {
    @Published var reminders = [ReminderModel]()
    @Published var currentReminder : ReminderModel = ReminderModel(reminder: "Default reminder")
    let db = Firestore.firestore()
    
    func fetchData() {
        self.reminders.removeAll()
        db.collection("reminders")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            self.reminders.append(try document.data(as: ReminderModel.self))
                        } catch {
                            print(error)
                        }
                    }
                    self.currentReminder = self.reminders.randomElement() ?? self.currentReminder
                }
            }
        
    }
    
    func saveData(reminder: ReminderModel) {
        if let id = reminder.id {
            print("id", id)
            // Edit note
            if !reminder.reminder.isEmpty {
                let docRef = db.collection("reminders").document(id)
                
                docRef.updateData([
                    "reminder" : reminder.reminder
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
        } else {
            // Add note
            if !reminder.reminder.isEmpty {
                var ref: DocumentReference? = nil
                ref = db.collection("reminders").addDocument(data: [
                    "reminder" : reminder.reminder
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            }
        }
    }
}
