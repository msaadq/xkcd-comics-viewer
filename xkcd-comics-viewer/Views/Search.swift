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
    @State private var searchText : String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView()
                Spacer()
            }
            .navigationBarTitle("Search")
        }
    }
}

struct SearchView: UIViewRepresentable {
    let controller = UISearchController()
    func makeUIView(context: UIViewRepresentableContext<SearchView>) -> UISearchBar {
        self.controller.searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchView>) {
        
    }
    
    typealias UIViewType = UISearchBar
    
    
}

//struct SearchBar: UIViewRepresentable {
//
//    @Binding var text: String
//    var placeholder: String
//
//    class Coordinator: NSObject, UISearchBarDelegate {
//
//        @Binding var text: String
//
//        init(text: Binding<String>) {
//            _text = text
//        }
//
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//        }
//    }
//
//    func makeCoordinator() -> SearchBar.Coordinator {
//        return Coordinator(text: $text)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
//        let searchBar = UISearchBar(frame: .zero)
//        searchBar.delegate = context.coordinator
//        searchBar.placeholder = placeholder
//        searchBar.searchBarStyle = .minimal
//        searchBar.autocapitalizationType = .none
//        return searchBar
//    }
//
//    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
//        uiView.text = text
//    }
//}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
