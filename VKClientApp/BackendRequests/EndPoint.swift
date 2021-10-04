//
//  EndPoints.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 01.10.2021.
//

import Foundation
enum EndPoint : String {
    case GET_USER_FRIENDS = "/method/friends.get"
    case GET_PHOTOS_BY_USER = "/method/photos.getAll"
    case GET_USER_GROUPS = "/method/groups.get"
    case SEARCH_GROUPS = "/method/groups.search"
    
}
