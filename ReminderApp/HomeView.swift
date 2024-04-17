//
//  HomeView.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 16/4/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authService = AuthenticationService()
    var body: some View {
        VStack {
            Button{authService.logOut()} label: {Text("Log Out")}
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    HomeView()
}
