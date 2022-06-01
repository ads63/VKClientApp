//
//  MainCoordinator.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.05.2022.
//

import Combine
import SwiftUI
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    private let session = SessionSettings.instance
    private var cancellables: Set<AnyCancellable> = []

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        let loginViewController = UIHostingController(rootView: WebLoginView())
        self.navigationController = UINavigationController(rootViewController: loginViewController)
    }

    func start() {
        session.$isUserLoggedIn.subscribe(on: RunLoop.main).sink { [weak self]
            isUserLoggedIn in
            guard let self = self else { return }
            if !isUserLoggedIn {
                self.navigationController.popToRootViewController(animated: true)
            } else {
                let tabBarView = self.getMainTabBarController()
                self.navigationController.pushViewController(tabBarView, animated: false)
            }
        }.store(in: &cancellables)
    }

    private func getMainTabBarController() -> UIViewController {
        let tabBarView = TabBarView()
        return UIHostingController(rootView: tabBarView)
    }
}
