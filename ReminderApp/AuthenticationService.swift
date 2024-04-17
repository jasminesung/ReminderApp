//
//  AuthenticationService.swift
//  ReminderApp
//
//  Created by Jasmine Sung on 16/4/2024.
//

import Foundation
import FirebaseAuth

@MainActor class AuthenticationService: ObservableObject {
    @Published var hasAuthError = false
    @Published var errorMessage = ""
    @Published var email = "jzs0266@auburn.edu"
    @Published var password = "candysweet"
    @Published var isLoggedIn = false
    @Published private var _currentUser : UserModel? = nil
    private var handler = Auth.auth().addStateDidChangeListener{_,_ in }
    
    var currentUser: UserModel {
            return _currentUser ?? UserModel(uid: "", email: "")
        }
    
    init(){
        handler = Auth.auth().addStateDidChangeListener{ auth,user in
            if let user = user {
                self._currentUser = UserModel(uid: user.uid, email: user.email!)
                self.isLoggedIn = true
            } else {
                self._currentUser = nil
                self.isLoggedIn = false
            }
        }
    }
    
    func signUp() async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        }
        catch {
            hasAuthError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func logIn() async {
        hasAuthError = false
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            hasAuthError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func logOut() {
        hasAuthError = false
        do {
            try Auth.auth().signOut()
        } catch {
            hasAuthError = true
            errorMessage = error.localizedDescription
        }
    }
}
