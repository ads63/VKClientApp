//
//  Friend.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 25.08.2021.
//


import RealmSwift

final class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var avatarURL: String?
    @objc dynamic var userName: String {
        return ((firstName ?? "") + " " + (lastName ?? ""))
            .trimmingCharacters(in: .whitespaces)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    override static func ignoredProperties() -> [String] {
        return ["userName"]
    }
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_50"
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(
            Int.self,
            forKey: .id)
        self.firstName = try container.decode(
            String.self,
            forKey: .firstName)
        self.lastName = try container.decode(
            String.self,
            forKey: .lastName)
        self.avatarURL = try container.decode(
            String.self,
            forKey: .avatarURL)
    }
}
