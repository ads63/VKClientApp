//
//  News.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.03.2022.
//

import Foundation
class News: NewsProtocol, Decodable {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()

    var type: String? = nil
    var date = 0
    var formattedDate: String

    func getType() -> String {
        return self.type!
    }

    func getDate() -> Int {
        return self.date
    }

    enum CodingKeys: String, CodingKey {
        case type
        case date
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(
            String.self,
            forKey: .type)
        self.date = try container.decode(
            Int.self,
            forKey: .date)
        self.formattedDate = PostNews.dateFormatter
            .string(from: Date(timeIntervalSince1970: Double(self.date)))
    }
}
