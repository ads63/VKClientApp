//
//  ParseDataOperation.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 02.02.2022.
//

import Foundation

class ParseDataOperation<T: Decodable>: Operation {
    var parsedData: T?

    override func main() {
        guard let getDataOperation = dependencies.first as? RestApiOperation,
              let data = getDataOperation.data else { return }
        do {
            parsedData = try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error \(error) while parsing data")
        }
    }
}
