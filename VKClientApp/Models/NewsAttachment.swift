//
//  NewsAttachment.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 15.11.2021.
//

import Foundation
class NewsAttachment: Decodable {
    var type: String
    var photos : Photo?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        if type == "photo" {
            self.photos = try container.decode(Photo.self, forKey: .photo)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case photo
    }
}
