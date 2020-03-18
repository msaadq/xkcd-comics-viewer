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
    @State var indexForUpdate = UserState.defaultComicsCount
    
    var body: some View {
        NavigationView {
            List {
                // TODO: - How to get index of cell
                ForEach(userState.comicsList.enumerated().map { $0 }, id: \.element.id) { index, comic in
                    NavigationLink(
                        destination: ComicDetails(comic: comic)
                    ) {
                        ComicCell(comic: comic).onAppear {
                            if index == self.indexForUpdate {
                                self.indexForUpdate += UserState.defaultComicsCount + 1
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

struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    fileprivate var configuration = { (indicator: UIView) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}

struct ComicsList_Previews: PreviewProvider {
    static var previews: some View {
        ComicsList()
    }
}
