//
//  ContainerView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var shouldShowMainView: Bool = false
    @ObservedObject var session = SessionSettings.instance
    var body: some View {
        NavigationView {
            HStack {
                AuthView(isUserLoggedIn: $shouldShowMainView)
                NavigationLink(destination: WebLoginView(), isActive: $shouldShowMainView) {
                    EmptyView()
                }
                NavigationLink(destination: TabBarView(), isActive: $session.isUserLoggedIn) { EmptyView() }
            }
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
