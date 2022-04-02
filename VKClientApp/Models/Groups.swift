//
//  Groups.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 29.08.2021.
//

import UIKit

struct Groups {
    static var groups = [
        Group(id: 0, image: UIImage(named: "MySQL"), groupName: "MySQL",
              isMember: false),
        Group(id: 1, image: UIImage(named: "oracle"), groupName: "Oracle",
              isMember: true),
        Group(id: 2, image: UIImage(named: "postgresql"), groupName: "PostgreSQL",
              isMember: true),
        Group(id: 3, image: UIImage(named: "PostgresPro"), groupName: "PostgresPro",
              isMember: false)
    ]
    static var filterJoined = ""
    static var filter2Join = ""

    static func resetGroups(newGroups: [Group]) {
        groups.removeAll()
        groups.append(contentsOf: newGroups)
    }

    static func getGroups2Join(filter: String = filter2Join) -> [Group] {
        return groups.filter { !$0.isMember && (filter.isEmpty || $0.groupName.lowercased().contains(filter.lowercased())) }
    }

    static func getJoinedGroups(filter: String = filterJoined) -> [Group] {
        return groups.filter { $0.isMember && (filter.isEmpty || $0.groupName.lowercased().contains(filter.lowercased())) }
    }

    static func joinGroup(index: Int) {
        let currentGroups = getGroups2Join()
        for i in 0 ..< groups.count {
            if currentGroups[index] == groups[i] {
                groups[i].isMember = true
                return
            }
        }
    }

    static func joinGroups(indexes: [Int]) {
        let currentGroups = getGroups2Join()
        for index in indexes {
            for i in 0 ..< groups.count {
                if currentGroups[index] == groups[i] {
                    groups[i].isMember = true
                    break
                }
            }
        }
    }

    static func leaveGroup(index: Int) {
        let currentGroups = getJoinedGroups()
        for i in 0 ..< groups.count {
            if currentGroups[index] == groups[i] {
                groups[i].isMember = false
                return
            }
        }
    }

    static func leaveGroups(indexes: [Int]) {
        let currentGroups = getJoinedGroups()
        for index in indexes {
            for i in 0 ..< groups.count {
                if currentGroups[index] == groups[i] {
                    groups[i].isMember = false
                    break
                }
            }
        }
    }
}
