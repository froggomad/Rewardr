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
import FirebaseFunctions

class DatabaseService {
    //MARK: - Firebase -
    private let _DB_BASE = Database.database().reference()
    private lazy var _REF_PARENTS = _DB_BASE.child("parent")
    private lazy var _REF_CHILDREN = _DB_BASE.child("children")
    private lazy var functions = Functions.functions()
    private let addChildIdentifier = "createUser"

    //MARK: - create/update parent -
    func updateParent(parent: Parent) {
        var parent = parent
        if let userID = Auth.auth().currentUser?.uid {            _REF_PARENTS.child(userID).setValue(parent.parentDict)
        }
    }
    //MARK: - create/update child -
    func createChild(for parent: Parent,
                     with firstName: String,
                     lastName: String,
                     displayName: String?,
                     chores: [Chore]?,
                     username: String,
                     password: String,
                     completion: @escaping (_ child: Child?) -> Void = {_ in }) {
        let funcCallDict = [
            "email": username,
            "password": password
        ]
        functions.httpsCallable(addChildIdentifier).call(funcCallDict) { (result, error) in
            if let error = error {
                NSLog("error: adding child with firebase function: \(error)")
                completion(nil)
            }

            if let httpResult = result?.data as? [String:Any] {
                guard let dataDict = httpResult["data"] as? [String:Any] else {
                    #warning("TODO: Error handling")
                    NSLog("No result from firebase function createUser")
                    return
                }
                guard let childID = dataDict["message"] as? String else {
                    #warning("TODO: Error handling")
                    return
                }
                let child = Child(id: childID,
                                  parent: parent,
                                  firstName: firstName,
                                  lastName: lastName,
                                  displayName: displayName ?? firstName,
                                  chores: chores ?? [])
                if child.parentId == AuthService.currentUserId {
                    #warning("TODO: Error handling")
                    //create child ID for parent
                    self._REF_PARENTS.child(Auth.auth().currentUser?.uid ?? "error").child("children").child(child.id).updateChildValues(child.childDetails()) { _,_ in
                        //create parent ID to login child
                        self._REF_CHILDREN.child(childID).child("parentID").setValue(Auth.auth().currentUser?.uid ?? "error")
                        completion(child)
                    }
                }
            }
        }
    }

    func updateChild(child: Child) {
        _REF_PARENTS
            .child(child.parentId)
            .child("children")
            .child(child.id)

            .updateChildValues(child.childDetails())
    }

    //MARK: - create/update chore -
    func updateChore(_ chore: Chore, to child: Child) {
        self._REF_PARENTS
            .child(child.parentId)
            .child("children")
            .child(child.id)
            .child("chores")

            .updateChildValues(chore.choreDict())
    }

    //MARK: - Read Parent -
    func downloadParent(with id: String) {
        
    }

    //MARK: - Read Children -
    func downloadChildren(for parent: Parent, complete: @escaping (_ children: [Child]?) -> Void) {
        _REF_PARENTS.child(parent.id).child("children").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let children = snapshot.value as? [NSDictionary] else { fatalError("firebase sucks")}
            print(children)
            if let children = children as? [Child] {
                complete(children)
            } else {
                complete(nil)
            }
//            var childrenArr: [Child] = []
//            for child in children {
//
//                childrenArr.append(child)
//            }
//            complete(childrenArr)
//          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }

    func downloadChildDetails(for id: String) {

    }
}
