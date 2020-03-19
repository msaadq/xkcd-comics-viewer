//
//  ExplanationView.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 19/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

struct ExplanationView: View {
    var urlString: String
    
    var body: some View {
        WebView(request: URLRequest(url: URL(string: urlString)!))
    }
}
