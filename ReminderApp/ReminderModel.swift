//
//  ReminderModel.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 27/4/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct ReminderModel: Codable, Identifiable {
    @DocumentID var id: String?
    var reminder: String
}
