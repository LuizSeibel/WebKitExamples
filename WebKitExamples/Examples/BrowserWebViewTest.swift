//
//  BrowserWebViewTest.swift
//  WebKitExamples
//
//  Created by Luiz Seibel on 15/07/25.
//

import SwiftUI

struct BrowserWebViewTest: View {
    
    let viewModel = BrowserViewModel()
    
    var body: some View {
        VStack{
            BrowserWebView(url: URL(string: viewModel.urlString)!, viewModel: viewModel)
                .ignoresSafeArea(edges: .horizontal)
            createSearchBar()
        }
    }
    
    private func createSearchBar() -> some View {
        SearchBar(
            viewModel: viewModel
        )
        .padding(.horizontal)
    }
}

#Preview {
    BrowserWebViewTest()
}


struct SearchBar: View {
    @ObservedObject var viewModel: BrowserViewModel
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 40)
                    .cornerRadius(12)
                    .foregroundColor(.red)
                HStack {
                    
                    Image("search")
                    TextField("Search", text: $viewModel.urlString)
                        .font(Font.system(size: 16))
                        .frame(height: 50)
                        .textFieldStyle(.plain)
                        .cornerRadius(12)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.loadURLString()
                        }
                    
                    
                    Button(action: {
                        viewModel.reload()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .background(.white)
                .cornerRadius(12)
            }
        }
    }
}
