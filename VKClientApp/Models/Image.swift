//
//  Image.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.10.2021.
//

import UIKit

final class Image {
    var height: Int = 0
    var width: Int = 0
    var type: String?
    var imageUrl: String?
    
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

