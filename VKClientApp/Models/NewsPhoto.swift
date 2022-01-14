//
//  NewsPhoto.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.11.2021.
//

import Foundation

class NewsPhoto: Decodable {
    var photo: Photo
    var flags = NewsFlags()
    var text = ""
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photo = try Photo(from: decoder)
        let likesContainer = try container
            .nestedContainer(keyedBy: CodingKeys.LikesKeys.self,
                             forKey: .likes)
        self.flags.likesCount = try likesContainer.decode(Int.self, forKey: .count)
        self.flags.isLiked = try likesContainer.decode(Int.self, forKey: .user_likes)
        let repostsContainer = try container
            .nestedContainer(keyedBy: CodingKeys.RepostsKeys.self,
                             forKey: .reposts)
        self.flags.repostsCount = try repostsContainer.decode(Int.self, forKey: .count)
        self.flags.isReposted = try repostsContainer.decode(Int.self, forKey: .user_reposted)
        let commentsContainer = try container
            .nestedContainer(keyedBy: CodingKeys.CommentsKeys.self,
                             forKey: .comments)
        self.flags.commentsCount = try commentsContainer.decode(Int.self, forKey: .count)
        self.flags.canRepost = try container.decode(Int.self, forKey: .can_repost)
        self.flags.canComment = try container.decode(Int.self, forKey: .can_comment)
        self.text = try container.decode(String.self, forKey: .text)
    }
    enum CodingKeys: String, CodingKey {
        case text
        case likes
        enum LikesKeys: String, CodingKey {
            case count
            case user_likes
        }
        case reposts
        enum RepostsKeys: String, CodingKey {
            case count
            case user_reposted
        }
        case comments
        enum CommentsKeys: String, CodingKey {
            case count
        }
        case can_comment
        case can_repost
    }
}
