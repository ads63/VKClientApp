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
//
    func getPostNews(startTime: Int = 0, startFrom: String? = nil,
                     completion: @escaping (ResponseNews<PostNews>) -> Void)
    {
        let path = EndPoint.getNews.rawValue
        var parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "start_time": String(startTime),
            "filters": "post"
        ]
        if startFrom != nil {
            parameters["start_from"] = startFrom
        }

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let newsData = try JSONDecoder()
                            .decode(ResponseNews<PostNews>.self, from: data)
                        DispatchQueue.main.async {
                            completion(newsData)
                        }

                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func getPhotoNews(startTime: Int = 0, startFrom: String? = nil,
                      completion: @escaping (ResponseNews<PhotoNews>) -> Void)
    {
        let path = EndPoint.getNews.rawValue
        var parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "start_time": String(startTime),
            "filters": "photo"
        ]
        if startFrom != nil {
            parameters["start_from"] = startFrom
        }

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let newsData = try JSONDecoder()
                            .decode(ResponseNews<PhotoNews>.self, from: data)
                        DispatchQueue.main.async {
                            completion(newsData)
                        }

                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func getFriends(fieldList: [String] = [],
                    offset: Int = 0)
    {
        let path = EndPoint.getUserFriends.rawValue
        var fields = Set<String>(["photo_50"]) // set mandatory fields
        fields.formUnion(fieldList) // add user defined fields
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "fields": fields.joined(separator: ",")
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let friends = try JSONDecoder().decode(Response<User>.self,
                                                               from: data).list
                        self?.session.realmService.insertUsers(users: friends)
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func getUserPhotos(userID: Int,
                       offset: Int = 0)
    {
        let path = EndPoint.getPhotosByUser.rawValue
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
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let photos = try JSONDecoder().decode(Response<Photo>.self,
                                                              from: data).list
                        self?.session.realmService.insertPhotos(photos: photos)
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func getUserGroups(fieldList: [String] = [],
                       extended: Int = 1,
                       offset: Int = 0)
    {
        var fields = Set<String>(["photo_50"]) // set mandatory fields
        fields.formUnion(fieldList) // add user defined fields
        let path = EndPoint.getUserGroups.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "offset": String(offset),
            "extended": String(extended),
            "fields": fields.joined(separator: ",")
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let groups = try JSONDecoder()
                            .decode(Response<Group>.self, from: data).list
                        self?.session.realmService.insertGroups(groups: groups)
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func searchGroups(searchString: String = "",
                      type: String = "group",
                      offset: Int = 0)
    {
        let path = EndPoint.searchGroups.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "type": type,
            "q": "\"" + searchString + "\"",
            "offset": String(offset)
        ]

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let groups = try JSONDecoder()
                            .decode(Response<Group>.self, from: data).list
                        self?.session.realmService.deleteGroups(groups:
                            [Group]((self?.session.realmService.selectNotMineGroups())!))
                        self?.session.realmService.insertGroups(groups: groups)
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func joinGroup(id: Int) {
        let path = EndPoint.joinGroup.rawValue
        let parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "group_id": String(id)
        ]
        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        _ = try JSONDecoder()
                            .decode(ResponseCode.self, from: data).result
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func leaveGroup(id: Int) {
        let path = EndPoint.leaveGroup.rawValue
        let parameters: Parameters = [
            "group_id": String(id),
            "v": session.api_version,
            "access_token": session.token
        ]
        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        _ = try JSONDecoder()
                            .decode(ResponseCode.self, from: data).result
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }
}
