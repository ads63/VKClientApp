//
//  EndPoints.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 01.10.2021.
//

import Foundation
enum EndPoint: String {
    case getUserFriends = "/method/friends.get"
    case getPhotosByUser = "/method/photos.getAll"
    case getUserGroups = "/method/groups.get"
    case searchGroups = "/method/groups.search"
    case leaveGroup = "/method/groups.leave"
    case joinGroup = "/method/groups.join"
    case getNews = "/method/newsfeed.get"
}
