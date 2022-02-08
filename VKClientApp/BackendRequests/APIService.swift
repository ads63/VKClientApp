//
//  APIService.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 01.10.2021.
//

import Alamofire
import Foundation
import PromiseKit
import RealmSwift
import SwiftyJSON

final class APIService {
    private let session = SessionSettings.instance
    private let host = SessionSettings.instance.host

    func getNewsFeed<T: Decodable>(ofType: T.Type,
                                   filters: String?,
                                   startTime: Int = 0,
                                   startFrom: String? = nil,
                                   completion: @escaping (ResponseNews<T>?) -> Void)
    {
        let path = EndPoint.getNews.rawValue
        var parameters: Parameters = [
            "access_token": session.token,
            "v": session.api_version,
            "start_time": String(startTime)
        ]
        if startFrom != nil {
            parameters["start_from"] = startFrom
        }
        if filters != nil {
            parameters["filters"] = filters
        }

        AF.request(
            host + path,
            method: .get,
            parameters: parameters)
            .resume()
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData(queue: DispatchQueue.global()) {
                [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let json = JSON(data)
                    let dispatchGroup = DispatchGroup()

                    let itemsJSONArray = json["response"]["items"].arrayValue
                    let profilesJSONArray = json["response"]["profiles"].arrayValue
                    let groupsJSONArray = json["response"]["groups"].arrayValue

                    var items = [T]()
                    var profiles = [User]()
                    var groups = [Group]()
                    let nextPointer = json["next_from"].stringValue

                    DispatchQueue.global().async(group: dispatchGroup) {
                        for (index, value) in itemsJSONArray.enumerated() {
                            do {
                                let item = try decoder
                                    .decode(T.self, from: value.rawData())
                                items.append(item)
                            } catch (let error) {
                                print("Decode items error \(error) at index \(index)")
                            }
                        }
                    }
                    DispatchQueue.global().async(group: dispatchGroup) {
                        for (index, value) in profilesJSONArray.enumerated() {
                            do {
                                let item = try decoder
                                    .decode(User.self, from: value.rawData())
                                profiles.append(item)
                            } catch (let error) {
                                print("Decode profiles error \(error) at index \(index)")
                            }
                        }
                    }
                    DispatchQueue.global().async(group: dispatchGroup) {
                        for (index, value) in groupsJSONArray.enumerated() {
                            do {
                                let item = try decoder
                                    .decode(Group.self, from: value.rawData())
                                groups.append(item)
                            } catch (let error) {
                                print("Decode groups error \(error) at index \(index)")
                            }
                        }
                    }
                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        let response = ResponseNews<T>(items: items,
                                                       profiles: profiles,
                                                       groups: groups,
                                                       pointer: nextPointer)
                        completion(response)
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

extension APIService {
    private func apiRequest(request: DataRequest) -> Promise<Data> {
        return Promise<Data> { resolver in
            request
                .resume()
                .validate(statusCode: 200..<201)
                .validate(contentType: ["application/json"])
                .responseData {
                    response in
                    switch response.result {
                    case .success(let value):
                        resolver.fulfill(value)
                    case .failure(let error):
                        resolver.reject(error)
                    }
                }
        }
    }

    private func parseUsersResponse(data: Data) -> Promise<[User]> {
        return Promise<[User]> { resolver in
            do {
                let value = try JSONDecoder().decode(Response<User>.self, from: data)
                resolver.fulfill(value.list)
            } catch {
                resolver.reject(error)
            }
        }
    }

    private func realmInsertUser(data: [User], dropBefore: Bool) -> Promise<Void> {
        return Promise<Void> { resolver in
            do {
                let realm = try Realm(configuration: RealmService.config)
                realm.beginWrite()
                if dropBefore {
                    realm.delete([User](realm.objects(User.self)))
                }
                realm.add(data, update: .all)
                try realm.commitWrite()
                resolver.fulfill(())
            } catch {
                resolver.reject(error)
            }
        }
    }

    func getFriendsByPromise(fieldList: [String] = [],
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
        let request = AF.request(
            host + path,
            method: .get,
            parameters: parameters)

        Promise { result in
            DispatchQueue.global().async {
                self.apiRequest(request: request).pipe(to: result.resolve)
            }
        }.then { data in
            self.parseUsersResponse(data: data)
        }.then { users in
            self.realmInsertUser(data: users, dropBefore: true)
        }.catch { error in
            print("\(error)")
        }
    }
}
