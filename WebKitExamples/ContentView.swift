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
    (function () {

      /** injeta código no documento de um iframe */
      function attachTo(doc) {

        if (!doc || doc.__feedbackHooked) return; // evita duplicar
        doc.__feedbackHooked = true;

        /* 1. Captura o clique (fase de CAPTURA para pegar antes do remove()) */
        doc.addEventListener('click', function (e) {
          const btn = e.target.closest('#feedback button');
          if (btn) {
            window.webkit.messageHandlers.appMessageHandler.postMessage('okClicked');
          }
        }, true);

        /* 2. Plano-B: se o nó #feedback for removido via jQuery .remove() */
        const obs = new MutationObserver((mutations) => {
          for (const m of mutations) {
            for (const n of m.removedNodes) {
              if (n.id === 'feedback' || (n.nodeType === 1 && n.querySelector &&
                                          n.querySelector('#feedback'))) {
                window.webkit.messageHandlers.appMessageHandler.postMessage('okClicked');
              }
            }
          }
        });
        obs.observe(doc.body, { childList: true, subtree: true });
      }

      /** tenta encontrar o iframe onde o jogo é renderizado */
      function tryInject() {
        const frame = document.getElementById('frame');
        if (frame && frame.contentWindow && frame.contentWindow.document.readyState !== 'loading') {
          attachTo(frame.contentWindow.document);
          clearInterval(loop);
          window.webkit.messageHandlers.appMessageHandler.postMessage('Injection ready');
        }
      }

      /* roda até o iframe terminar de carregar */
      const loop = setInterval(tryInject, 500);
    })();
    """
)
