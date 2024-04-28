//
//  AuthView.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 16/4/2024.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var authService = AuthenticationService()
    var body: some View {
        VStack {
            LabeledContent {TextField("", text: $authService.email)} label: {Text("📧 Email").bold()}
            LabeledContent{SecureField("", text: $authService.password)} label: {Text("✏️ Password").bold()}
            Button{Task {await authService.logIn()}} label: {Text("Log In")}
            Button{Task {await authService.signUp()}} label: {Text("Sign Up")}
        }
        .alert("Error", isPresented: $authService.hasAuthError) {} message: {Text(authService.errorMessage)}
        .padding()
    }
}

#Preview {
    AuthView()
}
