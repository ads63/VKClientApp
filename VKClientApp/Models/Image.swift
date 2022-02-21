//
//  Image.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.10.2021.
//

import CoreGraphics
import RealmSwift

final class Image: Object {
    @objc dynamic var height = 0
    @objc dynamic var width = 0
    @objc dynamic var type: String?
    @objc dynamic var imageUrl: String?

    let photo = LinkingObjects(fromType: Photo.self, property: "images")
}

extension Image: Decodable {
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case type
        case imageUrl = "url"
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.height = try container.decode(
            Int.self,
            forKey: .height)
        self.width = try container.decode(
            Int.self,
            forKey: .width)
        self.type = try container.decode(
            String.self,
            forKey: .type)
        self.imageUrl = try container.decode(
            String.self,
            forKey: .imageUrl)
    }
}
