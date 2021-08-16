//
//  ViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 16.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBAction func loginButtonPressed(_ sender: Any) {
        if isValid() {
            // valid login, do something
        } else {
            // invalid login, report error
        }
    }

    func isValid() -> Bool {
        return loginTextField.text != "" && passwordTextField.text != ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
