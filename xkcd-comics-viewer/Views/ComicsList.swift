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
            VStack {
                if !self.userState.connectionOnline {
                    VStack (spacing: 10) {
                        Text("No Internet Connection").font(.title)
                        Button(action: {
                            self.indexForUpdate = UserState.defaultComicsCount - 1
                            self.userState.loadLatestComic() }) {
                            Text("Tap to Retry!")
                        }
                    }
                } else {
                    if self.userState.comicsList.count == 0 {
                        ActivityIndicator(isAnimating: true)
                    }
                    else {
                        List {
                            ForEach(userState.comicsList.enumerated().map { $0 }, id: \.element.id) { index, comic in
                                NavigationLink(
                                    destination: ComicDetails(comic: comic).environmentObject(self.userState)
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
                    }
                }
            }
            .navigationBarTitle("Comics")
        }.onAppear {
            if self.userState.comicsList.count >= UserState.defaultComicsCount {
                self.indexForUpdate = self.userState.comicsList.count - 1
            }
        }
    }
}

struct ComicsList_Previews: PreviewProvider {
    static var previews: some View {
        ComicsList()
    }
}
