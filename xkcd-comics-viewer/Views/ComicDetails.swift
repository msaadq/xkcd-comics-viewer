//
//  ComicDetails.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import SwiftUI
import WebKit
  
struct WebView : UIViewRepresentable {
      
    let request: URLRequest
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
      
}

struct ComicDetails: View {
    @EnvironmentObject var userState: UserState
    @State var comic: Comic
    @State var imageFullscreen = false
    @State var explanationFullscreen = false
    @State var shouldAllowLandscape = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .center, spacing: 20) {
                if !self.userState.connectionOnline {
                    VStack (spacing: 10) {
                        Text("No Internet Connection").font(.title)
                        Button(action: {
                            self.userState.loadComicDetails(comic: self.comic) }) {
                                Text("Tap to Retry!")
                        }
                    }
                } else {
                    Text(comic.title).font(.title)
                    if comic.image != nil {
                        Button(action: { self.imageFullscreen = self.shouldAllowLandscape } ) {
                            VStack(spacing: 6) {
                                if self.shouldAllowLandscape {
                                    Text("(Tap to enlarge)").font(.caption)
                                }
                                Image(uiImage: comic.image!).renderingMode(.original).resizable().aspectRatio(contentMode: .fit)
                            }
                        }.disabled(!shouldAllowLandscape)
                            .sheet(isPresented: $imageFullscreen) {
                                ImageLandscapeView(image: self.comic.image!)
                        }
                        
                    } else {
                        ActivityIndicator(isAnimating: true)
                    }
                    Text("Posted: \(comic.publishedDate!.relativeTime)").font(.caption).italic()
                    Text(comic.alt).font(.caption).multilineTextAlignment(.center)
                    Button(action: {
                        self.userState.connectionOnline = Reachability.isConnectedToNetwork()
                        self.explanationFullscreen = self.userState.connectionOnline }) {
                        Text("Show Explanation")
                    }
                    .sheet(isPresented: self.$explanationFullscreen) {
                        ExplanationView(urlString: "\(APIService.comicExplanationBaseURL)\(APIService.Endpoint.explain(id: self.comic.id).path())")
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .onAppear {
            self.userState.loadComicDetails(comic: self.comic)
        }.onDisappear(){
            self.userState.comicDetails = nil
        }.onReceive(self.userState.$comicDetails) {
            self.comic.image = $0?.image
            if let image = self.comic.image {
                self.shouldAllowLandscape = image.size.height < image.size.width * 0.8
            }
        }
        .navigationBarTitle(Text("# \(comic.id)"))
    }
}

struct ComicDetails_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ComicDetails(comic: Comic.loadSampleComic()[0])
            ComicDetails(comic: Comic.loadSampleComic()[1])
            ComicDetails(comic: Comic.loadSampleComic()[2])
        }.environmentObject(UserState())
    }
}
