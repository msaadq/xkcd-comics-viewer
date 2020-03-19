//
//  ComicCell.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

struct ComicCell: View {
    var comic: Comic
    
    var body: some View {
        HStack {
            Text("\(comic.id)").font(.body).frame(width: 40)
            VStack(alignment: .leading, spacing: 10) {
                Text(comic.title).font(.title)
                Text(comic.publishedDate!.relativeTime).font(.caption).italic()
            }.padding()
        }
        
    }
}

struct ComicCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ComicCell(comic: Comic.loadSampleComic()[0])
            ComicCell(comic: Comic.loadSampleComic()[1])
            ComicCell(comic: Comic.loadSampleComic()[2])
        }
        .previewLayout(.sizeThatFits)
    }
}
