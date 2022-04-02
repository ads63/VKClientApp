//
//  APIAdapter.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.03.2022.
//

import RealmSwift
import UIKit

enum RealmEntity {
    case user, photo, group
}

final class APIAdapter: APIAdapterProtocol {
    private var realmNotificationTokens: [RealmEntity: NotificationToken] = [:]

    func searchGroups(searchString: String, completion: @escaping ([Group]?) -> Void) {
        if let realm = try? Realm(configuration: RealmService.config) {
            let groups = realm.objects(Group.self)
            realmNotificationTokens[.group]?.invalidate()
            let token = groups.observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(let groups, _, _, _):
                    completion(groups.filter { $0.isJoinCandidate }.map { $0 })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.group] = token
            AppSettings
                .instance
                .queuedService
                .searchGroups(searchString: searchString)
        }
    }

    func joinGroup(groupID: Int, completion: @escaping (Bool) -> Void) {
        if let realm = try? Realm(configuration: RealmService.config) {
            guard let group = realm.objects(Group.self)
                .filter("id == %@", groupID).first
            else { return }
            realmNotificationTokens[.group]?.invalidate()
            let token = realm.objects(Group.self).observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(_, let deleted, _, _):
                    completion(!deleted.isEmpty)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.group] = token
            AppSettings
                .instance
                .queuedService
                .joinGroup(group: group)
        }
    }

    func leaveGroup(groupID: Int, completion: @escaping ([Group]?) -> Void) {
        if let realm = try? Realm(configuration: RealmService.config) {
            guard let group = realm.objects(Group.self)
                .filter("id == %@", groupID).first
            else { return }
            realmNotificationTokens[.group]?.invalidate()
            let token = realm.objects(Group.self).observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(let groups, _, _, _):
                    completion(Array(groups.filter { !$0.isJoinCandidate }))
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.group] = token
            AppSettings
                .instance
                .queuedService
                .leaveGroup(group: group)
        }
    }

    func getUserGroups(completion: @escaping ([Group]?) -> Void) {
        if let realm = try? Realm(configuration: RealmService.config) {
            let groups = realm.objects(Group.self)
            realmNotificationTokens[.group]?.invalidate()
            let token = groups.observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(let groups, _, _, _):
                    completion(groups.filter { !$0.isJoinCandidate }.map { $0 })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.group] = token
            AppSettings
                .instance
                .queuedService
                .getUserGroups()
        }
    }

    func getFriends(completion: @escaping ([User]?) -> Void) {
        if let realm = try? Realm(configuration: RealmService.config) {
            let users = realm.objects(User.self)
            realmNotificationTokens[.user]?.invalidate()
            let token = users.observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(let users, _, _, _):
                    completion(users.map { $0 })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.user] = token
            AppSettings
                .instance
                .apiService
                .getFriendsByPromise()
        }
    }

    func getUserPhotos(userID: Int, completion: @escaping ([Photo]?) -> Void) {
        if let realm = try? Realm(configuration: RealmService.config) {
            let photos = realm.objects(Photo.self)
            realmNotificationTokens[.photo]?.invalidate()
            let token = photos.observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(let photos, _, _, _):
                    completion(photos.map { $0 })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.photo] = token
            AppSettings
                .instance
                .apiService
                .getUserPhotos(userID: userID)
        }
    }

    func getNewsFeed(startTime: Int = 0,
                     startFrom: [PostType: String?],
                     completion: @escaping ([PostType: ResponseNews<News>?]) -> Void)
    {
        AppSettings
            .instance
            .apiService
            .getNewsFeed(ofType: PostNews.self,
                         filters: "post",
                         startTime: startTime,
                         startFrom: startFrom[.post] ?? nil,
                         completion: {
                             [weak self] dataPost in
                             guard let dataPost = dataPost else { return }
                             var responseNews = [PostType: ResponseNews<News>?]()
                             responseNews[.post] =
                                 ResponseNews(items: dataPost.items.filter {
                                     !($0.text.isEmpty && $0.photos.isEmpty)
                                 },
                                 profiles: dataPost.profiles,
                                 groups: dataPost.groups,
                                 pointer: dataPost.nextPointer ?? "")
                             AppSettings
                                 .instance
                                 .apiService
                                 .getNewsFeed(ofType: PhotoNews.self,
                                              filters: "photo",
                                              startTime: startTime,
                                              startFrom: startFrom[.photo] ?? nil,
                                              completion: {
                                                  [weak self] dataPhoto in
                                                  guard let dataPhoto = dataPhoto
                                                  else { return }
                                                  responseNews[.photo] =
                                                      ResponseNews(items: dataPhoto.items
                                                          .filter {
                                                              !$0.photos.isEmpty
                                                          },
                                                          profiles: dataPhoto.profiles,
                                                          groups: dataPhoto.groups,
                                                          pointer: dataPhoto.nextPointer ?? "")
                                                  DispatchQueue.main.async {
                                                      completion(responseNews)
                                                  }

                                              })

                         })
    }

    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        AppSettings.instance.photoService.getImage(url: url, completion: {
            [weak self] image in
            completion(image)
        })
    }

    func loadImage(placeholderImage: UIImage?, toImageView: UIImageView?, url: String, onFailureImage: UIImage?) {
        AppSettings.instance.photoService.loadImage(placeholderImage: placeholderImage,
                                                    toImageView: toImageView,
                                                    url: url,
                                                    onFailureImage: onFailureImage)
    }
}
