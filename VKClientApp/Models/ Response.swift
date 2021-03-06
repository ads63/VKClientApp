//
//   Response.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 06.10.2021.
//

// import Foundation

class Response<T: Decodable>: Decodable {
    var list: [T]

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container
            .nestedContainer(keyedBy: CodingKeys.ResponseKeys.self,
                             forKey: .response)
        self.list = try responseContainer.decode([T].self, forKey: .list)
    }

    enum CodingKeys: String, CodingKey {
        case response
        enum ResponseKeys: String, CodingKey {
            case list = "items"
        }
    }
}
