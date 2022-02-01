//
//  PhotoNews.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.11.2021.
//

import Foundation

final class PhotoNews: NewsProtocol, Decodable {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()

    var type: String?
    var date = 0
    var sourceID = 0
    var photos = [NewsPhoto]()
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: Double(date))
        return PostNews.dateFormatter.string(from: date)
    }

    func getType() -> String {
        return self.type!
    }

    func getDate() -> Int {
        return self.date
    }

    enum CodingKeys: String, CodingKey {
        case type
        case source_id
        case date
        case photos
        enum PhotosKeys: String, CodingKey {
            case items
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(
            String.self,
            forKey: .type)
        self.date = try container.decode(
            Int.self,
            forKey: .date)
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
