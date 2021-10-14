//
//  Data.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 29.08.2021.
//

import UIKit

class Data {
    static let instance = Data()
    let appSettings = AppSettings.instance
    var friends = [User]()
    var groups = [Group]()
    private var groups2Join = [Group]()
    private var photos = [Photo]()

    var filterJoined = ""
    var filter2Join = ""

    func resetAllGroups() {
        loadJoinedGroups()
        loadGroups2Join(filter: filter2Join)
    }

    func loadJoinedGroups() {
        appSettings.apiService.getUserGroups {
            [weak self] groupsArray in
            self?.groups = groupsArray
        }
    }

    func loadFriends(view: UITableViewController, filter: String = "") {
        appSettings.apiService.getFriends(completion: {
            [weak self] dataArray in
            self?.friends = dataArray
            view.tableView.setNeedsDisplay()
//            view.layoutIfNeeded()
        })
    }

    func loadPhotos(userID: Int) {
        appSettings.apiService.getUserPhotos(userID: userID) {
            [weak self] dataArray in
            self?.photos = dataArray
        }
    }

    func loadGroups2Join(filter: String = "") {
        appSettings.apiService.searchGroups(searchString: filter) {
            [weak self] groupsArray in
            self?.groups2Join = groupsArray
        }
    }
    func getFriends() -> [User] { self.friends }
    func getPhotos() -> [Photo] { self.photos }

    func getGroups2Join(filter: String? = nil) -> [Group] {
        let currentFilter = filter ?? filter2Join
        let r = groups2Join.filter { currentFilter.isEmpty || $0.groupName!.lowercased().contains(currentFilter.lowercased()) }
        return r
    }

    func getJoinedGroups(filter: String? = nil) -> [Group] {
        let currentFilter = filter ?? filterJoined
        let r = groups.filter { currentFilter.isEmpty ||
            $0.groupName!.lowercased().contains(currentFilter.lowercased())}
        return r
    }

    func joinGroup(index: Int) {
        var apiResult = true
        let currentGroups = getGroups2Join()
        let id = currentGroups[index].id
        appSettings.apiService.joinGroup(id: id) {
            result in
            apiResult = result
        }
        if apiResult {
            for i in 0 ..< groups2Join.count {
                if currentGroups[index] == groups2Join[i] {
                    groups2Join.remove(at: i)
                    return
                }
            }
        }
    }

    func joinGroups(indexes: [Int]) {
        for index in indexes {
            joinGroup(index: index)
        }
    }

    func leaveGroup(index: Int) {
        var apiResult = true
        let currentGroups = getJoinedGroups()
        let id = currentGroups[index].id
        appSettings.apiService.leaveGroup(id: id) {
            result in
            apiResult = result
        }
        if apiResult {
            for i in 0 ..< groups.count {
                if currentGroups[index] == groups[i] {
                    groups.remove(at: i)
                    return
                }
            }
        }
    }

    func leaveGroups(indexes: [Int]) {
        for index in indexes {
            leaveGroup(index: index)
        }
    }
}
