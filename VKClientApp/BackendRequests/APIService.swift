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

    func getFriends(fieldList: [String] = [],
                    offset: Int = 0,
                    completion: @escaping ([User]) -> Void)
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
                response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let friends = try JSONDecoder().decode(Response<User>.self,
                                                               from: data).list
                        DispatchQueue.main.async {
                            completion(friends)
                        }
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func getUserPhotos(userID: Int,
                       offset: Int = 0,
                       completion: @escaping ([Photo]) -> Void)
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
                response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let photos = try JSONDecoder().decode(Response<Photo>.self,
                                                              from: data).list
                        DispatchQueue.main.async {
                            completion(photos)
                        }
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
                       offset: Int = 0,
                       completion: @escaping ([Group]) -> Void)
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
                response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let groups = try JSONDecoder()
                            .decode(Response<Group>.self, from: data).list
                        DispatchQueue.main.async {
                            completion(groups)
                        }
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
                      offset: Int = 0,
                      completion: @escaping ([Group]) -> Void)
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
                response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    do {
                        let groups = try JSONDecoder()
                            .decode(Response<Group>.self, from: data).list
                        DispatchQueue.main.async {
                            completion(groups)
                        }
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func joinGroup(id: Int,
                   completion: @escaping (Bool) -> Void)
    {
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
                        let result = try JSONDecoder()
                            .decode(ResponseCode.self, from: data).result
                        DispatchQueue.main.async {
                            completion(result == 1)
                        }
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }

    func leaveGroup(id: Int,
                    completion: @escaping (Bool) -> Void)
    {
        let path = EndPoint.leaveGroup.rawValue
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
                        let result = try JSONDecoder()
                            .decode(ResponseCode.self, from: data).result
                        DispatchQueue.main.async {
                            completion(result == 1)
                        }
                    } catch {
                        print("error \(error)")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
    }
}
