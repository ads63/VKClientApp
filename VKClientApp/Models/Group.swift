//
//  Group.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 25.08.2021.
//

import UIKit

final class Group: Equatable {
    var id: Int = 0
    var avatarURL: String?
    var groupName: String?
    var adminValue: Int = 0
    var memberValue: Int = 0
    var isJoinCandidate: Bool { return adminValue == 0 && memberValue == 0 }

    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
}

extension Group: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "photo_50"
        case groupName = "name"
        case adminValue = "is_admin"
        case memberValue = "is_member"
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(
            Int.self,
            forKey: .id)
        self.avatarURL = try container.decode(
            String.self,
            forKey: .avatarURL)
        self.groupName = try container.decode(
            String.self,
            forKey: .groupName)
        self.memberValue = try container.decode(
            Int.self,
            forKey: .memberValue)
        self.adminValue = try container.decode(
            Int.self,
            forKey: .adminValue)
    }
}
