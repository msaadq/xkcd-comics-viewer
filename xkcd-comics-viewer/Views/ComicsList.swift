//
//  ComicsList.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

struct ComicsList: View {
    @EnvironmentObject var userState: UserState
    @State var indexForUpdate = UserState.defaultComicsCount - 1
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userState.comicsList.enumerated().map { $0 }, id: \.element.id) { index, comic in
                    NavigationLink(
                        destination: ComicDetails(comic: self.$userState.comicsList[index])
                    ) {
                        ComicCell(comic: comic).onAppear {
                            if index == self.indexForUpdate {
                                self.indexForUpdate += UserState.defaultComicsCount
                                self.userState.loadComicsFrom(comicID: comic.id - 1)
                            }
                        }
                    }
                }
                
                if self.userState.continueLoadingComics {
                    VStack {
                        ActivityIndicator(isAnimating: true)
                    }
                }
            }
            .navigationBarTitle("Comics List")
        }
    }
}

struct ComicsList_Previews: PreviewProvider {
    static var previews: some View {
        ComicsList()
    }
}
