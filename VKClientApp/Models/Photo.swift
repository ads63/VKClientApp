//
//  Photo.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.10.2021.
//

import RealmSwift

final class Photo: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var likesCount = 0
    @objc dynamic var isLiked = 0
    var images = List<Image>()

    override static func primaryKey() -> String? {
        return "id"
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}

extension Photo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case sizes
        case likes
        enum LikesKeys: String, CodingKey {
            case count
            case user_likes
        }
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(
            Int.self,
            forKey: .id)
        self.images = try container.decode(List<Image>.self, forKey: .sizes)
        let likesContainer = try container
            .nestedContainer(keyedBy: CodingKeys.LikesKeys.self,
                             forKey: .likes)
        self.isLiked = try likesContainer.decode(Int.self, forKey: .user_likes)
        self.likesCount = try likesContainer.decode(Int.self, forKey: .count)
    }
}
