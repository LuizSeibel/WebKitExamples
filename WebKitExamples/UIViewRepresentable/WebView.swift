//
//  WebView.swift
//  WebKitExamples
//
//  Created by Luiz Seibel on 15/07/25.
//

import SwiftUI
import WebKit

struct JSInjectionModel {
    let JSInjectionScript: String
}

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var error: Error?
    
    // Monitoramento de vars
    @Binding var onSuccess: Bool?
    let jsInjection: JSInjectionModel?
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        if jsInjection != nil {
            webView.configuration.userContentController.add(context.coordinator, name: "appMessageHandler")
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Delegate method: Chamado quando a navegação começa.
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        // Delegate method: Chamado quando a navegação é concluída com sucesso.
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            
            // Injeta o JS quando a pagina carregar
            if parent.jsInjection != nil {
                parent.injectMonitorScript(into: webView)
            }
        }

        // Delegate method: Chamado quando a navegação falha.
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.error = error
            print("Erro ao carregar WebView: \(error.localizedDescription)")
        }

        // Delegate method: Chamado quando a navegação falha durante a carga inicial.
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.error = error
            print("Erro provisório ao carregar WebView: \(error.localizedDescription)")
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "appMessageHandler" {
                if let messageBody = message.body as? String {
                    print("Received message from JS: \(messageBody)")
                    if messageBody == "okClicked" {
                        parent.onSuccess = true
                        print("OK button was clicked in the web view!")
                    }
                }
            }
        }
    }
    
    private func injectMonitorScript(into webView: WKWebView){
        guard let jsInjection = jsInjection else { return }
        
        webView.evaluateJavaScript(jsInjection.JSInjectionScript) { (result, error) in
            if let error = error {
                print("Erro ao injetar script: \(error.localizedDescription)")
            } else {
                print("JavaScript Injetado com Sucesso!")
            }
        }
    }
}
