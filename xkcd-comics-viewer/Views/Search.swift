//
//  Search.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

struct Search: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $userState.searchText)
                if !userState.searchText.isEmpty && self.userState.searchResults == [] {
                    Spacer()
                    if !self.userState.connectionOnline {
                        VStack (spacing: 10) {
                            Text("No Internet Connection").font(.title)
                            Button(action: {
                                self.userState.searchComics(name: self.userState.searchText) }) {
                                    Text("Tap to Retry!")
                            }
                        }
                    } else {
                        ActivityIndicator(isAnimating: true)
                    }
                    Spacer()
                } else if self.userState.searchResults != [] {
                    List(userState.searchResults.enumerated().map { $0 }, id: \.element.id) { index, comic in
                        NavigationLink(
                            destination: ComicDetails(comic: comic).environmentObject(self.userState)
                        ) {
                            ComicCell(comic: comic)
                        }
                    }
                } else {
                    Spacer()
                }
            }.onReceive(self.userState.$searchText) {
                guard !$0.isEmpty else { self.userState.searchResults = []; return }
                self.userState.searchComics(name: $0)
            }
            .navigationBarTitle("Search")
        }
    }
}

struct SearchBar : UIViewRepresentable {
    
    @Binding var text : String
    
    class Cordinator : NSObject, UISearchBarDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            _text = text
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            text = searchBar.text ?? ""
            searchBar.resignFirstResponder()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                text = searchText
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
    
    func makeCoordinator() -> SearchBar.Cordinator {
        return Cordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search comics by ID or text"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
