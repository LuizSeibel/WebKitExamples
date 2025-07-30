//
//  BrowserWebView.swift
//  WebKitExamples
//
//  Created by Luiz Seibel on 15/07/25.
//

import SwiftUI
import Foundation
import WebKit

class BrowserViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    weak var webView: WKWebView? {
        didSet {
            webView?.navigationDelegate = self
        }
    }
    
    @Published var urlString: String = "https://www.google.com"
    
    func loadURLString() {
        guard let url = URL(string: urlString) else { return }
        webView?.load(URLRequest(url: url))
    }
    
    func reload() {
        webView?.reload()
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.urlString = webView.url?.absoluteString ?? ""
        }
    }
}

struct BrowserWebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: BrowserViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = viewModel
        viewModel.webView = webView
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
