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
                List(self.userState.searchResults) { comic in
                    NavigationLink(
                        destination: ComicDetails(comic: comic)
                    ) {
                        ComicCell(comic: comic)
                    }
                }.onReceive(self.userState.$searchText) {
                    guard !$0.isEmpty else { self.userState.searchResults = []; return }
                    self.userState.searchComics(name: $0)
                }
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
