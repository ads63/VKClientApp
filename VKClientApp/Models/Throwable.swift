//
//  Throwable.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 09.12.2021.
//

import Foundation

public class Throwable<T: Decodable>: Decodable {
    
    public let result: Result<T, Error>

    public required init(from decoder: Decoder) throws {
        let catching = { try T(from: decoder) }
        result = Result(catching: catching )
    }
}
