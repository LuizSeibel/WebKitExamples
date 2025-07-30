//
//  WebViewJSInjectionTest.swift
//  WebKitExamples
//
//  Created by Luiz Seibel on 15/07/25.
//

import SwiftUI

struct WebViewJSInjectionTest: View {
    let url: URL?
    let jsInjectionModel: JSInjectionModel
    @State private var webIsLoading = true
    @State private var error: Error? = nil
    @State private var onSuccess: Bool? = nil
    
    var body: some View {
        ZStack {
            if let error = error {
                Text("Error: \(error.localizedDescription)")
                    .padding()
            } else if let _url = url {
                WebView(url: _url,
                        isLoading: $webIsLoading,
                        error: $error,
                        onSuccess: $onSuccess,
                        jsInjection: jsInjectionModel)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
            }

            if webIsLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
            }

            if let success = onSuccess, success {
                VStack {
                    Spacer()
                    Text("Success: OK button clicked!")
                        .font(.headline)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
    }
}

#Preview("Learning Apps") {
    WebViewJSInjectionTest(url: URL(string: "https://learningapps.org/watch?v=p8ciu83ja25")!, jsInjectionModel: JSInjectionModelExample)
}
