//
//  GroupsViewModel.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import RealmSwift
import SwiftUI

class GroupsViewModel: ObservableObject {
    let groupViewModelFactory = GroupViewModelFactory()
    let realmService = SessionSettings.instance.realmService
    let objectWillChange = ObjectWillChangePublisher()
    var groups: [GroupViewModel] { groupViewModelFactory.constructViewModels(groups: realmGroups?.map { $0.detached() }) }
    private(set) lazy var realmGroups: Results<Group>? = realmService.selectMyGroups()
    private var notificationToken: NotificationToken?

    init() {
        notificationToken = realmGroups?.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    public func fetch() {
        AppSettings.instance.apiAdapter.getUserGroups { [weak self] groups in
            guard let self = self,
                  let groups = groups else { return }
            self.realmService.insertGroups(groups: groups)
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
