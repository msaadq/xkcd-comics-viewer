//
//  ComicDetails.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

struct ComicDetails: View {
    var comic: Comic
    
    var body: some View {
        VStack {
            Text(comic.title)
            Text("")
            Spacer()
        }
    }
}

struct ComicDetails_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetails(comic: Comic.loadSampleComic()!)
    }
}
