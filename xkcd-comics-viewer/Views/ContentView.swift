//
//  ContentView.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        TabView(selection: $selection){
            ComicsList().environmentObject(userState)
                .tabItem {
                    VStack {
                        Image(systemName: "list.dash").font(.title)
                        Text("Comics")
                    }.accentColor(.red)
            }
            .tag(0)
            Search().environmentObject(userState)
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass").font(.title)
                        Text("Search")
                    }
            }
            .tag(1)
        }.onAppear() {
            self.userState.loadLatestComic()
        }.onDisappear() {
            self.userState.cancellable?.cancel()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
