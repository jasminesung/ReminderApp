//
//  ContentView.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 16/4/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authService = AuthenticationService()
    var body: some View {
        if (authService.isLoggedIn) {
            HomeView()
        } else {
            AuthView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
