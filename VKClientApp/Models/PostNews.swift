//
//  News.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 15.11.2021.
//

import Foundation

class PostNews: News {
    var sourceID = 0
    var text: String = ""
    var attachments = [NewsAttachment]()
    var flags = NewsFlags()
    var photos: [Photo] { return self.attachments
        .filter { $0.type == "photo" }.map { $0.photos! }
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(
            String.self,
            forKey: .type)
        self.date = try container.decode(
            Int.self,
            forKey: .date)
        self.sourceID = try container.decode(Int.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.attachments = (try? container.decode(
            [NewsAttachment].self,
            forKey: .attachments)) ?? [NewsAttachment]()
        let comments = try container.nestedContainer(
            keyedBy: CodingKeys.CommentsKeys.self,
            forKey: .comments)
        self.flags.canComment = try comments.decode(Int.self, forKey: .canComment)
        self.flags.commentsCount = try comments.decode(Int.self, forKey: .count)
        let likes = try container.nestedContainer(
            keyedBy: CodingKeys.LikesKeys.self,
            forKey: .likes)
        self.flags.isLiked = try likes.decode(Int.self, forKey: .isLiked)
        self.flags.canLike = try likes.decode(Int.self, forKey: .canLike)
        self.flags.likesCount = try likes.decode(Int.self, forKey: .count)
        let reposts = try container.nestedContainer(
            keyedBy: CodingKeys.RepostsKeys.self,
            forKey: .reposts)
        self.flags.isReposted = try reposts.decode(Int.self, forKey: .isReposted)
        self.flags.repostsCount = try reposts.decode(Int.self, forKey: .count)
    }

    enum CodingKeys: String, CodingKey {
        case type
        case date
        case id = "source_id"
        case text
        case attachments
        case comments
        enum CommentsKeys: String, CodingKey {
            case canComment = "can_post"
            case count
        }

        case likes
        enum LikesKeys: String, CodingKey {
            case canLike = "can_like"
            case isLiked = "user_likes"
            case count
        }

        case reposts
        enum RepostsKeys: String, CodingKey {
            case isReposted = "user_reposted"
            case count
        }
    }
}
