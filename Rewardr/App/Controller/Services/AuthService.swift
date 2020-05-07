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
    static var currentUserId = Auth.auth().currentUser?.uid
    static var activeParent: Parent?
    //MARK: - Register -
    func registerUser(with email: String,
                      and password: String,
                      registrationComplete: @escaping (_ status: Bool, _ error: Error?, _ user: User?) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { (result, error) in
                                if error != nil {
                                    registrationComplete(false, error, nil)
                                    return
                                }
                                registrationComplete(true, nil, result?.user)
        }
    }

    //MARK: - Login -
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?, _ userType: UserType?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error, nil)
                return
            }
            #warning("TODO: Determine which type of user this is based on read access to children node (if false, it's a parent. They can only write there)")
            loginComplete(true, nil, .parent)
        }
    }
}
