//
//  Photo.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.10.2021.
//

import UIKit
import Nuke

final class Photo {
    var id : Int = 0
    var images: [Image] = []
}
extension Photo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case sizes
    }
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(
            Int.self,
            forKey: .id)
        self.images = try container.decode([Image].self, forKey: .sizes)
    }
}
