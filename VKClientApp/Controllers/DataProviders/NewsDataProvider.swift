//
//  NewsDataProvider.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.02.2022.
//

import Foundation
import UIKit
final class NewsDataProvider {
    private var controller: UITableViewController?
    private var rowWidth: CGFloat
    private var news = [NewsProtocol]()
    private var users = [User]()
    private var groups = [Group]()
    private var newsSections = [NewsSection]()
    private var nextFrom = [PostType: String?]()

    init(controller: UITableViewController?) {
        self.controller = controller
        self.rowWidth = self.controller?.tableView.bounds.width ?? 0
    }

    func getMaxNewsTime() -> Int? {
        news.sorted { $0.getDate() > $1.getDate() }.first?.getDate()
    }

    func getSectionsCount() -> Int {
        newsSections.count
    }

    func getRow(section: Int, row: Int) -> NewsRow? {
        if 0 ..< newsSections.count ~= section,
           0 ..< newsSections[section].newsRows.count ~= row
        {
            return newsSections[section].newsRows[row]
        }
        return nil
    }

    func getRowsCount(section: Int) -> Int {
        if 0 ..< newsSections.count ~= section {
            return newsSections[section].newsRows.count
        }
        return 0
    }

    func getNewNews(completion: @escaping (Int) -> Void) {
        let startTime = 1 + (getMaxNewsTime() ?? 0)
        let newsCountBefore = newsSections.count
        AppSettings
            .instance
            .apiService
            .getNewsFeed(ofType: PostNews.self,
                         filters: "post",
                         startTime: startTime,
                         completion: {
                             [weak self] dataPost in
                             guard let dataPost = dataPost else { return }
                             var news = [NewsProtocol]()
                             news
                                 .append(contentsOf:
                                     dataPost.items.filter {
                                         !($0.text.isEmpty && $0.photos.isEmpty)
                                     })
                             self?.users.append(contentsOf: dataPost.profiles)
                             self?.groups.append(contentsOf: dataPost.groups)
                             AppSettings
                                 .instance
                                 .apiService
                                 .getNewsFeed(ofType: PhotoNews.self,
                                              filters: "photo",
                                              startTime: startTime,
                                              completion: {
                                                  [weak self] dataPhoto in
                                                  guard let dataPhoto = dataPhoto
                                                  else { return }
                                                  news
                                                      .append(contentsOf:
                                                          dataPhoto.items.filter {
                                                              !$0.photos.isEmpty
                                                          })
                                                  self?.users.append(contentsOf:
                                                      dataPhoto.profiles)
                                                  self?.groups.append(contentsOf:
                                                      dataPhoto.groups)
                                              })

                             if let users = self?.users {
                                 self?.users = Array(Set(users))
                             }
                             if let groups = self?.groups {
                                 self?.groups = Array(Set(groups))
                             }
                             if let sections = self?.setRows(news: news) {
                                 self?.newsSections.insert(contentsOf: sections, at: 0)
                             }
                             let newsCountAfter = self?.newsSections.count ?? 0
                             let newsAdded = newsCountAfter - newsCountBefore
                             completion(newsAdded)
                         })
    }

    func getOldNews(completion: @escaping (Int) -> Void) {
        let newsCountBefore = newsSections.count
        let startFrom = nextFrom[PostType.post] ?? nil
        AppSettings
            .instance
            .apiService
            .getNewsFeed(ofType: PostNews.self,
                         filters: "post",
                         startTime: 0,
                         startFrom: startFrom,
                         completion: {
                             [weak self] dataPost in
                             guard let dataPost = dataPost else { return }
                             var news = [NewsProtocol]()
                             news
                                 .append(contentsOf:
                                     dataPost.items.filter {
                                         !($0.text.isEmpty && $0.photos.isEmpty)
                                     })
                             self?.users.append(contentsOf: dataPost.profiles)
                             self?.groups.append(contentsOf: dataPost.groups)
                             self?.nextFrom[PostType.post] = dataPost.nextPointer
                             let startFrom = self?.nextFrom[PostType.photo] ?? nil
                             AppSettings
                                 .instance
                                 .apiService
                                 .getNewsFeed(ofType: PhotoNews.self,
                                              filters: "photo",
                                              startTime: 0,
                                              startFrom: startFrom,
                                              completion: {
                                                  [weak self] dataPhoto in
                                                  guard let dataPhoto = dataPhoto
                                                  else { return }
                                                  news
                                                      .append(contentsOf:
                                                          dataPhoto.items.filter {
                                                              !$0.photos.isEmpty
                                                          })
                                                  self?.users.append(contentsOf:
                                                      dataPhoto.profiles)
                                                  self?.groups.append(contentsOf:
                                                      dataPhoto.groups)
                                                  self?.nextFrom[PostType.photo] =
                                                      dataPhoto.nextPointer
                                              })

                             if let users = self?.users {
                                 self?.users = Array(Set(users))
                             }
                             if let groups = self?.groups {
                                 self?.groups = Array(Set(groups))
                             }
                             if let sections = self?.setRows(news: news) {
                                 self?.newsSections.append(contentsOf: sections)
                             }
                             let newsCountAfter = self?.newsSections.count ?? 0
                             let newsAdded = newsCountAfter - newsCountBefore
                             completion(newsAdded)
                         })
    }

    func getNews(startTime: Int = 0,
                 startFrom: String? = nil)
    {
        AppSettings
            .instance
            .apiService
            .getNewsFeed(ofType: PostNews.self,
                         filters: "post",
                         startTime: startTime,
                         startFrom: startFrom,
                         completion: {
                             [weak self] dataPost in
                             guard let dataPost = dataPost else { return }
                             self?.news = [NewsProtocol]()
                             self?.users = [User]()
                             self?.groups = [Group]()
                             self?.news
                                 .append(contentsOf:
                                     dataPost.items.filter {
                                         !($0.text.isEmpty && $0.photos.isEmpty)
                                     })
                             self?.users.append(contentsOf: dataPost.profiles)
                             self?.groups.append(contentsOf: dataPost.groups)
                             self?.nextFrom[PostType.post] = dataPost.nextPointer
                             AppSettings
                                 .instance
                                 .apiService
                                 .getNewsFeed(ofType: PhotoNews.self,
                                              filters: "photo",
                                              startTime: startTime,
                                              startFrom: startFrom,
                                              completion: {
                                                  [weak self] dataPhoto in
                                                  guard let dataPhoto = dataPhoto
                                                  else { return }
                                                  self?.news
                                                      .append(contentsOf:
                                                          dataPhoto.items.filter {
                                                              !$0.photos.isEmpty
                                                          })
                                                  self?.users.append(contentsOf:
                                                      dataPhoto.profiles)
                                                  self?.groups.append(contentsOf:
                                                      dataPhoto.groups)
                                                  self?.nextFrom[PostType.photo] =
                                                      dataPhoto.nextPointer
                                              })
                             if let users = self?.users {
                                 self?.users = Array(Set(users))
                             }
                             if let groups = self?.groups {
                                 self?.groups = Array(Set(groups))
                             }
                             self?.newsSections = self?.setRows(news: self?.news)
                                 ?? [NewsSection]()

                             self?.controller?.tableView.reloadData()
                         })
    }

    private func setRows(news: [NewsProtocol]?) -> [NewsSection] {
        var newsSections = [NewsSection]()
        guard var news = news else { return newsSections }
        news.sort { $0.getDate() > $1.getDate() }
        for newsItem in news {
            switch newsItem.getType() {
            case "post":
                if let section = setPostRows(item: newsItem) {
                    newsSections.append(section)
                }
            case "photo",
                 "wall_photo":
                if let section = setPhotoRows(item: newsItem) {
                    newsSections.append(section)
                }
            default:
                break
            }
        }
        return newsSections
    }

    private func getAvatarURL(sourceID: Int) -> String? {
        sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.avatarURL :
            users.first(where: { $0.id == sourceID })?.avatarURL
    }

    private func getSourceName(sourceID: Int) -> String? {
        sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.groupName :
            users.first(where: { $0.id == sourceID })?.userName
    }

    private func setPostRows(item: NewsProtocol) -> NewsSection? {
        guard let postItem = item as? PostNews else { return nil }
        let section = NewsSection()
        let avatarURL = getAvatarURL(sourceID: postItem.sourceID)
        let srcName = getSourceName(sourceID: postItem.sourceID)
        section.newsRows.append(NewsRow(photo: URL(string: avatarURL!),
                                        srcName: srcName,
                                        date: postItem.formattedDate))
        section.newsRows.append(NewsRow(text: postItem.text))
        for photo in postItem.photos {
            let image = getImage(photo: photo,
                                 width: rowWidth)
            section.newsRows.append(NewsRow(photo: image.imageURL,
                                            width: image.width,
                                            height: image.height))
        }
        section.newsRows.append(NewsRow(likes: postItem.flags.likesCount,
                                        isLiked: postItem.flags.isLiked,
                                        comments: postItem.flags.commentsCount,
                                        canComment: postItem.flags.canComment,
                                        reposts: postItem.flags.repostsCount,
                                        isReposted: postItem.flags.isReposted))
        return section
//        newsSections.append(section)
    }

    private func setPhotoRows(item: NewsProtocol) -> NewsSection? {
        guard let photoItem = item as? PhotoNews else { return nil }
        let section = NewsSection()
        let sourceID = photoItem.sourceID
        let avatarURL = sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.avatarURL :
            users.first(where: { $0.id == sourceID })?.avatarURL
        let srcName = sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.groupName :
            users.first(where: { $0.id == sourceID })?.userName
        section.newsRows.append(NewsRow(photo: URL(string: avatarURL!),
                                        srcName: srcName,
                                        date: photoItem.formattedDate))
        for photo in photoItem.photos {
            let image = getImage(photo: photo.photo,
                                 width: rowWidth)
            section.newsRows.append(NewsRow(photo: image.imageURL,
                                            width: image.width,
                                            height: image.height))
            if !photo.text.isEmpty {
                section.newsRows.append(NewsRow(text: photo.text))
            }
            section.newsRows.append(NewsRow(likes: photo.flags.likesCount,
                                            isLiked: photo.flags.isLiked,
                                            comments: photo.flags.commentsCount,
                                            canComment: photo.flags.canComment,
                                            reposts: photo.flags.repostsCount,
                                            isReposted: photo.flags.isReposted))
        }
//        newsSections.append(section)
        return section
    }

    private func getImage(photo: Photo, width: CGFloat) -> NewsImage {
        let fullImageList = photo.images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList
            .filter { CGFloat($0.width) >= width }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let image = filteredImageList.first
        else { return NewsImage(url: nil, width: 1, height: 1) }
        let url = URL(string: image.imageUrl!)
        return NewsImage(url: url, width: image.width, height: image.height)
    }
}

enum PostType: String {
    case post
    case photo
}
