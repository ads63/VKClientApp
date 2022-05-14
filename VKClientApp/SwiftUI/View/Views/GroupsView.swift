//
//  GroupsView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI

struct GroupsView: View {
    @ObservedObject var viewModel: GroupsViewModel

    init(viewModel: GroupsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.groups.sorted(by: { $0.name < $1.name })) { group in
            GroupViewCell(group: group)
        }
        .onAppear { viewModel.fetch() }
    }
}
