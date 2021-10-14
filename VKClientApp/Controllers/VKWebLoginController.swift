//
//  VKWebLoginController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 01.10.2021.
//

import UIKit
import WebKit

final class VKWebLoginController: UIViewController {
    let data = Data.instance
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    private var urlComponents: URLComponents = {
        var urlComp = URLComponents()
        urlComp.scheme = "https"
        urlComp.host = "oauth.vk.com"
        urlComp.path = "/authorize"
        urlComp.queryItems = [
            URLQueryItem(name: "client_id", value: SessionSettings.instance.app_Id),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: SessionSettings.instance.api_version)
        ]
        return urlComp
    }()
    
    private lazy var request = URLRequest(url: urlComponents.url!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(request)
    }
}

extension VKWebLoginController: WKNavigationDelegate {

    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else { return decisionHandler(.allow) }
            
        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, params in
                var dict = result
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
            }
        guard
            let token = parameters["access_token"],
            let userIDString = parameters["user_id"],
            let userID = Int(userIDString)
        else { return decisionHandler(.allow) }
            
        SessionSettings.instance.token = token
        SessionSettings.instance.userId = userID
        performSegue(
            withIdentifier: "loginSegue",
            sender: nil)
            
        decisionHandler(.cancel)
    }
}
