//
//  PhotoNews.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.11.2021.
//

import Foundation

final class PhotoNews: News {
    var sourceID = 0
    var photos = [NewsPhoto]()

    enum CodingKeys: String, CodingKey {
        case source_id
        case photos
        enum PhotosKeys: String, CodingKey {
            case items
        }
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceID = try container.decode(
            Int.self,
            forKey: .source_id)
        let photosContainer = try container
            .nestedContainer(keyedBy: CodingKeys.PhotosKeys.self,
                             forKey: .photos)
        self.photos = try photosContainer.decode(
            [NewsPhoto].self,
            forKey: .items)
    }
}
