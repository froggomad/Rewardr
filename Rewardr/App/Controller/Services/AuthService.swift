//
//  AuthService.swift
//  Rewardr
//
//  Created by Kenny on 4/26/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    enum UserType {
        case parent
        case child
    }
    static var instance = AuthService()
    static var currentUserId = Auth.auth().currentUser?.uid
    static var activeParent: Parent?
    static var activeChild: Child?

    private let databaseService = DatabaseService()
    //MARK: - Register -
    func registerUser(with email: String,
                      and password: String,
                      registrationComplete: @escaping (
        _ status: Bool,
        _ error: Error?,
        _ user: User?) -> Void
    ) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { (result, error) in
            if error != nil {
                registrationComplete(false, error, nil)
                return
            }
            registrationComplete(true, nil, result?.user)
        }
    }

    //MARK: - Login -
    func loginUser(
        withEmail email: String,
        andPassword password: String,
        loginComplete: @escaping (
        _ status: Bool,
        _ error: Error?,
        _ userType: UserType?,
        _ userDetails: [String:Any]?) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { (auth, error) in
            if error != nil {
                loginComplete(false, error, nil, nil)
                return
            }
            self.databaseService.isChild(
                id: Auth.auth().currentUser?.uid ?? "no"
            ) { (childStatus, parentId) in
                if childStatus {
                    self.databaseService.downloadChildDetails(
                        for: AuthService.currentUserId ?? "no",
                        with: parentId ?? "no"
                    ) { (dictionary) in
                        loginComplete(true, nil, .child, dictionary)
                        return
                    }
                } else {
                    self.databaseService.downloadParentDetails(for: Auth.auth().currentUser?.uid ?? "no") { parentDictionary in
                        loginComplete(true, nil, .parent, parentDictionary)
                    }
                }
            }
        }
    }
}
