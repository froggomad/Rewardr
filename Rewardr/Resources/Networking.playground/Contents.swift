import UIKit


typealias ParentRep = [UUID:Parent]

struct Parent: Codable, Equatable {
    let id: UUID
    let firstName: String
    let lastName: String
    var children: [Child]

    static func == (lhs: Parent, rhs: Parent) -> Bool {
        lhs.id == rhs.id
    }
}

typealias ChildRep = [UUID:Child]

struct Child: Codable, Equatable {
    let id: UUID
    let parentId: String
    let parentName: String
    var firstName: String
    var lastName: String
    var displayName: String
    var points: Int

    static func == (lhs: Child, rhs: Child) -> Bool {
        lhs.id == rhs.id
    }

    init(id: UUID = UUID(),
         parent: Parent,
         firstName: String,
         lastName: String,
         displayName: String,
         points: Int = 0) {

        self.id = id
        parentName = "\(parent.firstName) \(parent.lastName)"
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName
        self.points = points
    }
}



let baseURL = URL(string: "https://rewardr-12eca.firebaseio.com")!
let parentURL = baseURL.appendingPathComponent("parent")

let child = Child(id: UUID(),
firstName: "Isabella",
lastName: "Dubroff",
displayName: "Bella",
points: 0)

let parent = Parent(id: UUID(uuidString: "3431B764-9AC7-4911-A345-F95635654546")!,
firstName: "Kenny",
lastName: "Dubroff",
children: [child])



let parentData = try! JSONEncoder().encode(parent)
func signUp(with parent: Parent) {
    let url = parentURL.appendingPathComponent(parent.id.uuidString)
        .appendingPathExtension("json")

    var request = URLRequest(url: url)
    request.httpBody = parentData
    request.httpMethod = "PATCH"
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("error retrieving data: \(error)")
            return
        }

        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            if statusCode != 200 {
                print("Bad status code: \(statusCode)")
            }
        }
    }.resume()
}

//signUp(with: parent)

func download(from parent: Parent) {
    let url = parentURL.appendingPathComponent(parent.id.uuidString)
    .appendingPathExtension("json")

    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("error retrieving details: \(error)")
            return
        }

        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            if statusCode != 200 {
                print("bad status code: \(statusCode)")
            }
        }

        if let data = data {
            print(String(data: data, encoding: .utf8)!)
            print(try! JSONDecoder().decode(ParentRep.self, from: data))
        }
    }.resume()
}

download(from: parent)
