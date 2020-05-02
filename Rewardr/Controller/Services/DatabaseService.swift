//
//  DatabaseService.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseService {
    //MARK: - Firebase -
    private let _DB_BASE = Database.database().reference()
    private lazy var _REF_PARENTS = _DB_BASE.child("parent")

    //MARK: - create/update parent -
    func updateParent(firstName: String, lastName: String) {
        if let userID = Auth.auth().currentUser?.uid {
            var parent = Parent(id: userID,
                                firstName: firstName,
                                lastName: lastName,
                                children: [],
                                rewards: [])

            _REF_PARENTS.child(parent.id).setValue(parent.parentDict)
        }
    }
    //MARK: - create/update child -
    func createChild(for parent: Parent,
                     with firstName: String,
                     lastName: String,
                     displayName: String,
                     chores: [Chore]?,
                     username: String,
                     password: String) {


        AuthService().registerUser(with: username, and: password) { (status, error, user) in
            if let error = error {
                print("Error registering child: \(error)")
                return
            }
            if status {
                guard let user = user else { return }
                var child = Child(id: user.uid,
                                  parent: parent,
                                  firstName: firstName,
                                  lastName: lastName,
                                  displayName: displayName,
                                  chores: chores ?? [])
                self._REF_PARENTS.child(parent.id).child("children").child(child.id).updateChildValues(child.childDict)
            }
        }
    }


    //MARK: - create/update chore -
    func updateChore(_ chore: Chore, to child: Child) {
        var chore = chore
        self._REF_PARENTS.child(child.parentId).child("children").child(child.id).child("chores").updateChildValues(chore.choreDict)
    }






//    //MARK: - REST -
//    private let baseURL = URL(string: "https://rewardr-12eca.firebaseio.com")!
//    private lazy var parentURL = baseURL.appendingPathComponent("parent")
//
//    func downloadChildren(from parent: Parent, complete: @escaping ([Child]?) -> Void) {
//        let parentJSONURL = parentURL.appendingPathComponent(parent.id)
//            .appendingPathExtension("json")
//        guard let downloadRequest = NetworkService.createRequest(url: parentJSONURL,
//                                                                 method: .get,
//                                                                 headerEntries: []) else { return }
//        NetworkService.networkSession(with: downloadRequest) { (status) in
//            guard let data = status.data else {
//                NSLog(
//                    """
//                    Error error downloading data: \(#file), \(#function), \(#line): \(String(describing: status.error))
//                    """)
//                complete(nil)
//                return
//            }
//            guard let childRep = NetworkService.decode(to: ChildRep.self, data: data) else {
//                print(String(data: data, encoding: .utf8)!)
//                complete(nil)
//                return
//            }
//            complete(childRep.children.map { $1 })
//        }
//    }
//
//    func update(child: Child) {
//        let childURL = parentURL.appendingPathComponent(child.parentId)
//            .appendingPathComponent("children").appendingPathComponent(child.id).appendingPathExtension("json")
//        let childData = try! JSONEncoder().encode(child)
//        guard var childUpdateRequest = NetworkService.createRequest(url: childURL, method: .patch) else {
//
//            return
//        }
//        childUpdateRequest.httpBody = childData
//        NetworkService.networkSession(with: childUpdateRequest) { status in
//            guard let data = status.data else {
//                NSLog(
//                    """
//                    Error updating \(child.displayName): \(#file), \(#function), \(#line) -
//                    \(String(describing: status.error))
//                    """)
//                return
//            }
//            print("Data sent: \(data)")
//        }
//    }
}
