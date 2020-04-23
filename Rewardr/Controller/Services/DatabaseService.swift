//
//  DatabaseService.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class DatabaseService {
    private let baseURL = URL(string: "https://rewardr-12eca.firebaseio.com")!
    private lazy var parentURL = baseURL.appendingPathComponent("parent")

    func downloadChildren(from parent: Parent, complete: @escaping ([Child]?) -> Void) {
        let parentJSONURL = parentURL.appendingPathComponent(parent.id.uuidString)
            .appendingPathExtension("json")
        guard let downloadRequest = NetworkService.createRequest(url: parentJSONURL,
                                                                 method: .get,
                                                                 headerEntries: []) else { return }
        NetworkService.networkSession(with: downloadRequest) { (status) in
            guard let data = status.data else {
                NSLog(
                    """
                    Error error downloading data: \(#file), \(#function), \(#line): \(String(describing: status.error))
                    """)
                complete(nil)
                return
            }
            guard let childRep = NetworkService.decode(to: ChildRep.self, data: data) else {
                print(String(data: data, encoding: .utf8)!)
                complete(nil)
                return
            }
            complete(childRep.children.map { $1 })
        }
    }

    func update(child: Child) {
        let childURL = parentURL.appendingPathComponent(child.parentId.uuidString)
            .appendingPathComponent("children").appendingPathComponent(child.id.uuidString).appendingPathExtension("json")
        let childData = try! JSONEncoder().encode(child)
        guard var childUpdateRequest = NetworkService.createRequest(url: childURL, method: .patch) else { return }
        childUpdateRequest.httpBody = childData
        NetworkService.networkSession(with: childUpdateRequest) { status in
            guard let _ = status.data else {
                NSLog(
                    """
                    Error updating \(child.displayName): \(#file), \(#function), \(#line) -
                    \(String(describing: status.error))
                    """)
                return
            }
        }
    }
}
