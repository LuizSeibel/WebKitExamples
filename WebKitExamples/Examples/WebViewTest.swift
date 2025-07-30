//
//  WebViewTest.swift
//  WebKitExamples
//
//  Created by Luiz Seibel on 15/07/25.
//

import SwiftUI

struct WebViewTest: View {
    @State private var webIsLoading = true
    @State private var error: Error? = nil
    let url: URL?

    var body: some View {
        ZStack {
          if let error = error {
            Text("Error: \(error.localizedDescription)")
                  .padding()
          } else if let _url = url {
              WebView(url: _url, isLoading: $webIsLoading, error: $error, onSuccess: .constant(nil), jsInjection: nil)
                  .edgesIgnoringSafeArea([.bottom, .horizontal])
            if webIsLoading {
                VStack{
                    ProgressView()
                    Text("Loading...")
                }
            }
          }
        }
    }
}

#Preview("Apple") {
    WebViewTest(url: URL(string: "https://www.apple.com")!)
}

#Preview ("No Existing URL") {
    WebViewTest(url: URL(string: "https://siteinexistente.com")!)
}

#Preview ("No HTTPS URL") {
    WebViewTest(url: URL(string: "http://siteinexistente.com")!)
}
