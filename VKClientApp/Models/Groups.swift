//
//  Groups.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 29.08.2021.
//

import Foundation
import UIKit

struct Groups {
    static var groups = [
        Group(image: UIImage(named: "MySQL"), groupName: "MySQL", isMember: false),
        Group(image: UIImage(named: "oracle"), groupName: "Oracle", isMember: true),
        Group(image: UIImage(named: "postgresql"), groupName: "PostgreSQL", isMember: true),
        Group(image: UIImage(named: "PostgresPro"), groupName: "PostgresPro", isMember: false)
    ]
    static func resetGroups(newGroups: [Group]) {
        groups.removeAll()
        groups.append(contentsOf: newGroups)
    }

    static func getGroups2Join() -> [Group] {
        return groups.filter { !$0.isMember }
    }

    static func getJoinedGroups() -> [Group] {
        return groups.filter { $0.isMember }
    }

    static func joinGroup(index: Int) {
        var counter = 0
        for i in 0 ..< groups.count {
            if !groups[i].isMember {
                if counter == index {
                    groups[i].isMember = true
                    return
                } else {
                    counter += 1
                }
            }
        }
    }

    static func leaveGroup(index: Int) {
        var counter = 0
        for i in 0 ..< groups.count {
            if groups[i].isMember {
                if counter == index {
                    groups[i].isMember = false
                    return
                } else {
                    counter += 1
                }
            }
        }
    }
}
