//
//  ComicsList.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

// MARK: - Comics List View
struct ComicsList: View {
    @EnvironmentObject var userState: UserState
    @State var indexForUpdate = UserState.defaultComicsCount - 1
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Network connection error message
                if !self.userState.connectionOnline {
                    VStack (spacing: 10) {
                        Text("No Internet Connection")
                            .font(.title)
                        Button(action: {
                            self.indexForUpdate = UserState.defaultComicsCount - 1
                            self.userState.loadLatestComic()
                        }) {
                            Text("Tap to Retry!")
                        }
                    }
                } else {
                    // MARK: - Loading indicator while list is retrieved
                    if self.userState.comicsList.count == 0 {
                        ActivityIndicator(isAnimating: true)
                    }
                    else {
                        // MARK: - Infinite scrollable comics list
                        List {
                            ForEach(userState.comicsList.enumerated().map { $0 }, id: \.element.id) { index, comic in
                                NavigationLink(
                                    destination: ComicDetails(comic: comic)
                                        .environmentObject(self.userState)
                                ) {
                                    ComicCell(comic: comic)
                                        .onAppear {
                                        if index == self.indexForUpdate {
                                            self.indexForUpdate += UserState.defaultComicsCount
                                            self.userState.loadComicsFrom(comicID: comic.id - 1)
                                        }
                                    }
                                }
                            }
                            // MARK: - Loading indicator under the list
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
        }
        .onAppear {
            // MARK: - Refresh view state on tab switch
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
