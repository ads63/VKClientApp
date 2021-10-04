//
//  APIService.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 01.10.2021.
//

import Alamofire
import Foundation

final class APIService {
    private let session = SessionSettings.instance
    private let host = "https://api.vk.com"

    func getFriends(fieldList: [String], offset: Int = 0) {
        let path = EndPoint.GET_USER_FRIENDS.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "fields": fieldList.joined(separator: ",")
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    print("success \(value)")
                case .failure(let error):
                    print(error)
                }
            }
    }

    func getUserPhotos(userID: Int, offset: Int = 0) {
        let path = EndPoint.GET_PHOTOS_BY_USER.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "owner_id": String(userID)
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    print("success \(value)")
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func getUserGroups(fieldList: [String],
                       extended: Int = 0,
                       offset: Int = 0)
    {
        let path = EndPoint.GET_USER_GROUPS.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "extended": String(extended),
            "fields": fieldList.joined(separator: ",")
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    print("success \(value)")
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func searchGroups(searchString: String, offset: Int = 0) {
        let path = EndPoint.SEARCH_GROUPS.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "q": searchString
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    print("success \(value)")
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }
}
