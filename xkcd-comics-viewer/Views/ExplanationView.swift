//
//  ExplanationView.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 19/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI
import WebKit

// MARK: - Explanation view for loading the explanation web page
struct ExplanationView: View {
    var urlString: String
    
    var body: some View {
        WebView(request: URLRequest(url: URL(string: urlString)!))
    }
}

// MARK: - WebView providing the web page to ExplanationView
struct WebView : UIViewRepresentable {
    let request: URLRequest
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
