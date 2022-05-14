//
//  TabBarView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            FriendsView(viewModel: FriendsViewModel())
                .navigationBarTitle("", displayMode: .inline)
                .tabItem {
                    SwiftUI.Image(systemName: "person.2.fill")
                    Text("Friends")
                }

            GroupsView(viewModel: GroupsViewModel())
                .navigationBarTitle("", displayMode: .inline)
                .tabItem {
                    SwiftUI.Image(systemName: "person.3.sequence.fill")
                    Text("Groups")
                }
            NewsView()
                .navigationBarTitle("", displayMode: .inline)
                .tabItem {
                    SwiftUI.Image(systemName: "newspaper.fill")
                    Text("News")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
