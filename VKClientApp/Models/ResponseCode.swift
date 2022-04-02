//
//  ResponseCode.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.10.2021.
//

 import Foundation
class ResponseCode: Decodable {
    var result: Int?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try? container.decode(Int.self, forKey: .response)
    }

    enum CodingKeys: String, CodingKey {
        case response
    }
}
