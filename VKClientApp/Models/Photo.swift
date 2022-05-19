//
//  Photo.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.10.2021.
//

import RealmSwift

final class Photo: Object, Identifiable {
    @objc dynamic var id = 0
    var images = List<Image>()
    var likes: Likes?

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
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(
            Int.self,
            forKey: .id)
        self.images = try container.decode(List<Image>.self, forKey: .sizes)
        self.likes = try container.decode(Likes.self, forKey: .likes)
    }
}
