//
//  LoginViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 16.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var rightDotImage: UIImageView!
    @IBOutlet var centerDotImage: UIImageView!
    @IBOutlet var leftDotImage: UIImageView!

    var session = SessionSettings.instance

    @IBAction func loginButtonPressed(_ sender: Any) {
        if isValid() {
            // valid login, do something
            performSegue(
                withIdentifier: "loginSegue",
                sender: nil)
        } else {
            // invalid login, report error
            showAlert()
        }
    }

    func showAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Incorrect username or password",
            preferredStyle: .alert)
        let alertItem = UIAlertAction(
            title: "press to continue",
            style: .cancel) { _ in
                self.loginTextField.text = ""
                self.passwordTextField.text = ""
        }
        alertController.addAction(alertItem)
        present(alertController,
                animated: true,
                completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [
                .repeat,
                .autoreverse
            ]) {
            self.leftDotImage.alpha = 0
        }
        UIView.animate(
            withDuration: 1,
            delay: 0.5,
            options: [
                .repeat,
                .autoreverse
            ]) {
            self.centerDotImage.alpha = 0
        }
        UIView.animate(
            withDuration: 1,
            delay: 1,
            options: [
                .repeat,
                .autoreverse
            ]) {
            self.rightDotImage.alpha = 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        loginTextField.text = ""
        passwordTextField.text = ""

        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        navigationController?.navigationBar.isHidden = false
    }

    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(
            forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue)
            .cgRectValue
            .size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                                         bottom: kbSize.height, right: 0.0)

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .required
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .defaultHigh
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .defaultHigh
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .required
            self.view.layoutIfNeeded()
        }
    }

    func isValid() -> Bool {
        loginTextField.text != "" && passwordTextField.text != ""
//        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)))
    }

    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
