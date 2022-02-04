//
//  ResponseNews.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 15.11.2021.
//

import Foundation
import SwiftUI

struct ResponseNews<T: Decodable>: Decodable {
    var items: [T] = []
    var profiles: [User] = []
    var groups: [Group] = []
    var nextPointer: String = ""

    init(items: [T], profiles: [User], groups: [Group], pointer: String) {
        self.items = items
        self.profiles = profiles
        self.groups = groups
        self.nextPointer = pointer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container
            .nestedContainer(keyedBy: CodingKeys.ResponseKeys.self,
                             forKey: .response)

        self.items = try responseContainer.decode([T].self,
                                                  forKey: .items)
        self.profiles = try decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.ResponseKeys.self,
                             forKey: .response).decode([User].self,
                                                       forKey: .profiles)
        self.groups = try decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.ResponseKeys.self,
                             forKey: .response).decode([Group].self,
                                                       forKey: .groups)

        self.nextPointer = try responseContainer.decode(String.self,
                                                        forKey: .next_from)
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
