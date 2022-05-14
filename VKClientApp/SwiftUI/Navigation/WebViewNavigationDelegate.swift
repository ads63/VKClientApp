//
//  WebViewNavigationDelegate.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI
import WebKit

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    @ObservedObject var session = SessionSettings.instance
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                
                return dict
            }
        
        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              let userID = Int(userIdString)
              
        else {
            decisionHandler(.allow)
            return
        }
        
        session.token = token
        session.userId = userID
        session.isUserLoggedIn = true
        session.realmService.dropDB()

        decisionHandler(.cancel)
    }
}
