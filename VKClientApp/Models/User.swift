//
//  Friend.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 25.08.2021.
//

import UIKit

final class User: Equatable {
    var id: Int = 0
    var firstName: String?
    var lastName: String?
    var avatarURL: String?
    var userName: String {
        ((firstName ?? "") + " " + (lastName ?? ""))
            .trimmingCharacters(in: .whitespaces)
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
