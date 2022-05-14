//
//  WebLoginView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI
import WebKit

struct WebLoginView: UIViewRepresentable {
    @ObservedObject var session = SessionSettings.instance

    fileprivate let navigationDelegate = WebViewNavigationDelegate()

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = navigationDelegate
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let request = getAuthRequest() {
            uiView.load(request)
        }
    }

    private func getAuthRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: SessionSettings.instance.app_Id),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: SessionSettings.instance.api_version)
        ]

        return components.url.map { URLRequest(url: $0) }
    }
}
