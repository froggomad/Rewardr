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
        if let userID = Auth.auth().currentUser?.uid {
            _REF_PARENTS
                .child(userID)
                .setValue(parent.parentDict)
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
                if child.parentId == Auth.auth().currentUser?.uid {
                    #warning("TODO: Error handling")
                    //create child ID for parent
                    self._REF_PARENTS.child(Auth.auth().currentUser?.uid ?? "error").child("children").child(child.id).updateChildValues(child.childDetails()) { _,_ in
                        //create parent ID used to login child
                        self._REF_CHILDREN.child(childID).child("parentID").setValue(Auth.auth().currentUser?.uid ?? "error")
                        completion(child)
                    }
                } else {
                    print("child.parentId != Auth.auth().currentuser?.uid")
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

    func getChildren(for parent: Parent) {
        self._REF_PARENTS.child(parent.id).child("children").observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
        }
    }

    //MARK: - Read Children -
    func downloadChildren(for parent: Parent, complete: @escaping (_ children: [Child]?) -> Void) {
        _REF_PARENTS.child(parent.id).child("children").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let childrenDict = snapshot.value as? [String:Any] else { return }
            var children = [Child?]()
            for (key, child) in childrenDict {
                let child = Child(childDict: [key:child])
                children.append(child)
            }
            complete(children.compactMap { $0 })
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

    func isChild(id: String, complete: @escaping (_ isChild: Bool, _ parentId: String?) -> Void) {

        _REF_CHILDREN.child(id).observeSingleEvent(of: .value) { childSnapshot in
            if childSnapshot.exists() {
                guard let childDict = childSnapshot.value as? NSDictionary,
                    let parentId = childDict["parentID"] as? String else {
                        complete(false, nil)
                        return
                }
                complete(true, parentId)
                return
            }
        }
        //it wasn't a child, return parent's ID
        self._REF_PARENTS.child(id).observeSingleEvent(of: .value) { parentSnapshot in
            if parentSnapshot.exists() {
                guard let parentDict = parentSnapshot.value as? NSDictionary,
                    let swiftDict = parentDict as? [String:Any],
                    let id = swiftDict.keys.first else {
                        complete(false, nil)
                        return
                }
                complete(false, id)
            }
        }
    }

    func downloadChildDetails(for childWithId: String, with parentId: String, complete: @escaping (_ childDetails: [String:Any]?) -> Void) {
        _REF_PARENTS.child(parentId).child("children").child(childWithId).observeSingleEvent(of: .value) { snapshot in
            dump(snapshot)
            complete([snapshot.key:snapshot.value as Any])
            return
        }
        print(
            """
            Is this a parent? Access was probably denied
            """
        )
        complete(nil)
    }

    func downloadParentDetails(
        for id: String,
        complete: @escaping (_ parentDetails: [String:Any]?) -> Void) {
        _REF_PARENTS.child(id).observeSingleEvent(of: .value) { snapshot in
            complete([snapshot.key:snapshot.value as Any])
            return
        }
        
        print(
            """
            Is this a child? Access was probably denied
            """
        )
        complete(nil)
    }
}
