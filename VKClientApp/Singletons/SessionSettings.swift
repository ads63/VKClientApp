//
//  Session.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 28.09.2021.
//

import Foundation

class SessionSettings {
    static let instance = SessionSettings()
    var token = ""
    var userId = 0
    var app_Id = "7965015"
    let api_version = "5.131"
    let enabledPhotoType = ["s", "m", "x", "y", "z", "w"]
    var filter2Join = ""
    var filterJoined = ""
    let realmService = RealmService()
    let host = "https://api.vk.com"
}
