//
//  NewsProtocol.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 29.11.2021.
//

import Foundation
protocol NewsProtocol {
    func getType() -> String
    func getDate() -> Int
    var formattedDate: String { get }
    static var dateFormatter: DateFormatter {get}

}
