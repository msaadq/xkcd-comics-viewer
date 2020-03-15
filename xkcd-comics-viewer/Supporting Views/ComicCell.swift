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
        VStack(alignment: .leading) {
            Text(comic.safeTitle + " " + String(comic.id))
            // TODO: - How to print date
            //Text("\(comic.publishedDate)")
        }
    }
}

struct ComicCell_Previews: PreviewProvider {
    static var previews: some View {
        ComicCell(comic: Comic.loadSampleComic()!)
    }
}
