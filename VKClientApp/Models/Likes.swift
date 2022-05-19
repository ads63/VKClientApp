//
//  Likes.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 19.05.2022.
//

import Foundation
class Likes: Decodable {
    var likesCount: Int?
    var isLiked: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case user_likes
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.likesCount = try container.decode(
            Int.self,
            forKey: .count)
        if let userLikes = try? container.decode(Int.self, forKey: .user_likes) {
            self.isLiked = userLikes == 1
        } else { self.isLiked = false }
    }
}
