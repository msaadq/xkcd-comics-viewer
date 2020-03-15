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
    @State var loadingMoreItems: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                // TODO: - How to get index of cell
//                if true {
//                    self.userState.loadComicsFrom(comicID: $0.id)
//                }
//                if $0 == 20 {
//                    self.userState.loadComicsFrom(comicID:  self.userState.comicsList[$0].id)
//                }
                ForEach(userState.comicsList) { comic in
                    ComicCell(comic: comic).onAppear {
                        let loadInAdvance = UserState.defaultComicsCount - 1
                        if comic.id == self.userState.scrollPosition - loadInAdvance {
                            print("New Load!")
                            self.userState.loadComicsFrom(comicID:  comic.id - 1)
                            self.userState.scrollPosition = comic.id - 1
                        }
                    }
                }
            
                if self.userState.scrollPosition > 0 {
                    VStack(alignment: .center) {
                        ActivityIndicator(isAnimating: true)
                    }
                }
            }
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
