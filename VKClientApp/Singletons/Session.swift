//
//  Session.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 28.09.2021.
//

import Foundation
class Session {
    static let instance = Session()
    private init() {}
    var token = ""
    var userId = 0
}
