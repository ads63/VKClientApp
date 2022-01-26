//
//  ResponseNews.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 15.11.2021.
//

import Foundation

class ResponseNews<T: Decodable>: Decodable {

    var items: [T] = []
    var profiles: [User] = []
    var groups: [Group] = []
    var nextPointer: String = ""

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container
            .nestedContainer(keyedBy: CodingKeys.ResponseKeys.self,
                             forKey: .response)
        self.items = try responseContainer.decode([T].self, forKey: .items)
        self.profiles = try responseContainer.decode([User].self, forKey: .profiles)
        self.groups = try responseContainer.decode([Group].self, forKey: .groups)
        do {
            self.nextPointer = try responseContainer.decode(String.self, forKey: .next_from)
        } catch {
            self.nextPointer = ""
            
        }
    }

    enum CodingKeys: String, CodingKey {
        case response
        enum ResponseKeys: String, CodingKey {
            case items
            case profiles
            case groups
            case next_from
        }
    }
}
