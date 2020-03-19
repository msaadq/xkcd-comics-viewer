//
//  Search.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

// MARK: - Search tab for seaching comics by ID and name
struct Search: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $userState.searchText)
                if !userState.searchText.isEmpty && self.userState.searchResults == [] {
                    Spacer()
                    // MARK: - Network connection error message
                    if !self.userState.connectionOnline {
                        VStack (spacing: 10) {
                            Text("No Internet Connection")
                                .font(.title)
                            Button(action: {
                                self.userState.searchComics(name: self.userState.searchText) }) {
                                    Text("Tap to Retry!")
                            }
                        }
                    } else {
                        // MARK: - Loading indicator while search is performed
                        ActivityIndicator(isAnimating: true)
                    }
                    Spacer()
                } else if self.userState.searchResults != [] {
                    // MARK: - List of search results
                    List(userState.searchResults.enumerated().map { $0 }, id: \.element.id) { index, comic in
                        NavigationLink(
                            destination: ComicDetails(comic: comic)
                                .environmentObject(self.userState)
                        ) {
                            ComicCell(comic: comic)
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .onReceive(self.userState.$searchText) {
                // MARK: - Search operation on searchText update
                guard !$0.isEmpty else { self.userState.searchResults = []; return }
                self.userState.searchComics(name: $0)
            }
            .navigationBarTitle("Search")
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
