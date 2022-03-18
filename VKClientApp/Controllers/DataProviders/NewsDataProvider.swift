//
//  NewsDataProvider.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.02.2022.
//

import Foundation
import UIKit
final class NewsDataProvider {
    private let newsSectionFactory = NewsSectionFactory()
    private var controller: UITableViewController?
    private var rowWidth: CGFloat
    private var newsSections = [NewsSection]()
    private var nextFrom = [PostType: String?]()
    private var maxNewsTime: Int?

    init(controller: UITableViewController?) {
        self.controller = controller
        self.rowWidth = self.controller?.tableView.bounds.width ?? 0
    }

    func getMaxNewsTime() -> Int? { maxNewsTime }

    func getSectionsCount() -> Int {
        newsSections.count
    }

    func getRow(section: Int, row: Int) -> NewsViewModel? {
        if 0 ..< newsSections.count ~= section,
           0 ..< newsSections[section].newsRows.count ~= row
        {
            return newsSections[section].newsRows[row]
        }
        return nil
    }

    func isExpanable(section: Int, row: Int) -> Bool {
        if let row = getRow(section: section, row: row),
           row.cellType == CellType.text,
           let text = row.text,
           text.count > 200
        {
            return true
        }
        return false
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
            .apiAdapter
            .getNewsFeed(startTime: startTime,
                         startFrom: [PostType: String?](),
                         completion: {
                             [weak self] data in
                             var news = [NewsProtocol]()
                             var users = [User]()
                             var groups = [Group]()
                             for item in data {
                                 if let responseData = item.value {
                                     news.append(contentsOf: responseData.items)
                                     groups.append(contentsOf: responseData.groups)
                                     users.append(contentsOf: responseData.profiles)
                                 }
                             }
                             users = Array(Set(users))
                             groups = Array(Set(groups))
                             self?.setMaxNewsTime(news: news)
                             self?.insertNewsSections(news: news,
                                                      users: users,
                                                      groups: groups)
                             let newsCountAfter = self?.newsSections.count ?? 0
                             let newsAdded = newsCountAfter - newsCountBefore
                             completion(newsAdded)
                         })
    }

    func getOldNews(completion: @escaping (Int) -> Void) {
        let newsCountBefore = newsSections.count
        AppSettings
            .instance
            .apiAdapter
            .getNewsFeed(startTime: 0,
                         startFrom: nextFrom,
                         completion: {
                             [weak self] data in
                             var news = [NewsProtocol]()
                             var users = [User]()
                             var groups = [Group]()
                             for item in data {
                                 if let responseData = item.value {
                                     news.append(contentsOf: responseData.items)
                                     groups.append(contentsOf: responseData.groups)
                                     users.append(contentsOf: responseData.profiles)
                                     self?.nextFrom[item.key] = responseData.nextPointer
                                 }
                             }
                             users = Array(Set(users))
                             groups = Array(Set(groups))
                             self?.setMaxNewsTime(news: news)
                             self?.appendNewsSections(news: news,
                                                      users: users,
                                                      groups: groups)

                             let newsCountAfter = self?.newsSections.count ?? 0
                             let newsAdded = newsCountAfter - newsCountBefore
                             completion(newsAdded)
                         })
    }

    func getNews() {
        AppSettings
            .instance
            .apiAdapter
            .getNewsFeed(startTime: 0,
                         startFrom: [PostType: String?](),
                         completion: {
                             [weak self] data in
                             var news = [NewsProtocol]()
                             var users = [User]()
                             var groups = [Group]()
                             for item in data {
                                 if let responseData = item.value {
                                     news.append(contentsOf: responseData.items)
                                     groups.append(contentsOf: responseData.groups)
                                     users.append(contentsOf: responseData.profiles)
                                     self?.nextFrom[item.key] = responseData.nextPointer
                                 }
                             }
                             users = Array(Set(users))
                             groups = Array(Set(groups))
                             self?.setMaxNewsTime(news: news)
                             self?.replaceNewsSections(
                                 news: news,
                                 users: users,
                                 groups: groups)
                             self?.controller?.tableView.reloadData()
                         })
    }

    private func insertNewsSections(news: [NewsProtocol]?,
                                    users: [User]?,
                                    groups: [Group]?)
    {
        newsSections.insert(contentsOf: buildNewsSections(news: news,
                                                          users: users,
                                                          groups: groups), at: 0)
    }

    private func appendNewsSections(news: [NewsProtocol]?,
                                    users: [User]?,
                                    groups: [Group]?)
    {
        newsSections.append(contentsOf: buildNewsSections(news: news,
                                                          users: users,
                                                          groups: groups))
    }

    private func replaceNewsSections(news: [NewsProtocol]?,
                                     users: [User]?,
                                     groups: [Group]?)
    {
        newsSections = buildNewsSections(news: news,
                                         users: users,
                                         groups: groups)
    }

    private func buildNewsSections(news: [NewsProtocol]?,
                                   users: [User]?,
                                   groups: [Group]?) -> [NewsSection]
    {
        return newsSectionFactory
            .constructViewModels(width: rowWidth,
                                 news: news,
                                 users: users,
                                 groups: groups)
    }

    private func setMaxNewsTime(news: [NewsProtocol]?) {
        guard let news = news else { return }
        let newTime = news.sorted { $0.getDate() > $1.getDate() }
            .first?.getDate() ?? 0
        maxNewsTime = max(maxNewsTime ?? 0, newTime)
    }
}

enum PostType: String {
    case post
    case photo
}
