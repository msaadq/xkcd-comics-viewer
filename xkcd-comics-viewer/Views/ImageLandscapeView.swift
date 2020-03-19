//
//  ImageLandscapeView.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 19/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

// MARK: - ImageLandscapeView for displaying a zoomed in version of landscape comics
struct ImageLandscapeView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: UIImage
    
    var body: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(uiImage: image)
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.degrees(90))
        }
    }
}
