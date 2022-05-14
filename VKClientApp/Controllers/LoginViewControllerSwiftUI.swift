//
//  LoginViewControllerSwiftUI.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 05.05.2022.
//

import SwiftUI
import UIKit

class LoginViewControllerSwiftUI: UIViewController {
    @State private var shouldShowMainView: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let authView = AuthView(isUserLoggedIn: $shouldShowMainView)
        let hostingController = UIHostingController(rootView: authView)
        hostingController.rootView.presentWebLogin = {
            let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_WEB_LOGIN")
            hostingController.present(destinationController, animated: true, completion: nil)
        }
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
