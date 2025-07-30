//
//  ContentView.swift
//  WebKitExamples
//
//  Created by Luiz Seibel on 15/07/25.
//

import SwiftUI

enum NavigationCases{
    case jsinjection
    case browser
    case noExistingURL
    case noHTTPSURL
    case showURL
}

struct ContentView: View {
    @State private var navigationCases: NavigationCases = .showURL

    var body: some View {
        NavigationStack {
            VStack{
                switch navigationCases {
                case .jsinjection:
                    WebViewJSInjectionTest(
                        url: URL(string: "https://learningapps.org/watch?v=p8ciu83ja25")!,
                        jsInjectionModel: JSInjectionModelExample
                    )
                case .browser:
                    BrowserWebViewTest()
                case .noHTTPSURL:
                    WebViewTest(url: URL(string: "http://siteinexistente.com")!)
                case .noExistingURL:
                    WebViewTest(url: URL(string: "https://siteinexistente.com")!)
                case .showURL:
                    WebViewTest(url: URL(string: "https://www.apple.com")!)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("WebView Examples")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Show URL") {
                            navigationCases = .showURL
                        }
                        Button("No URL") {
                            navigationCases = .noExistingURL
                        }
                        Button("No HTTPS") {
                            navigationCases = .noHTTPSURL
                        }
                        Button("JS Injection") {
                            navigationCases = .jsinjection
                        }
                        Button("Browser") {
                            navigationCases = .browser
                        }
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


let JSInjectionModelExample: JSInjectionModel = .init(JSInjectionScript:
    """
    (function(){
        // Tenta injetar dentro do iframe com id "frame"
        function injectToFrame() {
            const frame = document.getElementById('frame');
            if (!frame || !frame.contentWindow) return false;
            const doc = frame.contentWindow.document;
            if (!doc) return false;

            // Delegação de evento dentro do documento do iframe
            doc.addEventListener('click', function(e) {
                if (e.target.matches('#feedback button')) {
                    window.webkit.messageHandlers.appMessageHandler.postMessage('okClicked');
                }
            }, true);

            return true;
        }

        // Verifica a cada 500ms até conseguir injetar
        const intervalId = setInterval(function() {
            if (injectToFrame()) {
                clearInterval(intervalId);
                window.webkit.messageHandlers.appMessageHandler.postMessage('Injection Confirmation');
            }
        }, 500);

        // Retorno nulo para evaluateJavaScript
        null;
    })();
    """
)
