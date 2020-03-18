//
//  UserState.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import Foundation
import Combine

// MARK: - User State
class UserState: ObservableObject {
    @Published var comicsList: [Comic] = []
    @Published var comicDetails: Comic!
    @Published var searchResults: [Comic] = []
    @Published var selectedComicIndex: Int!
    @Published var continueLoadingComics = true
    @Published var connectionOnline = true
    
    static let defaultComicsCount: Int = 20
    
    var cancellable: AnyCancellable?
    
    private var latestComicID: Int!
    
    // MARK: - Public API
    
    // MARK: - Load latest comic with additional recent comics
    func loadLatestComic(additionalCount: Int = defaultComicsCount) {
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline, additionalCount >= 0 else { return }
        
        self.comicsList = []
        
        cancellable = APIService.shared.getAPIResponseMapper(modelObject: Comic.self, endpoint: .latest)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Success")
                }
            }, receiveValue: {
                self.latestComicID = $0.id
                self.loadComicsFrom(comicID: self.latestComicID)
            })
    }
    
    // MARK: - load additional recent comics starting from a comic position
    func loadComicsFrom(comicID: Int, for count: Int = defaultComicsCount) {
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline, comicID > 0 && count > 0 else { return }
        
        self.continueLoadingComics = true
        
        let comicIDs = Array(comicID-count...comicID)
        self.loadComicsWith(comicIDs: comicIDs)
    }
    
    // MARK: - Load all comics using a list of comic IDs
    func loadComicsWith(comicIDs: [Int]) {
        let correctComicIDs = comicIDs.filter { $0 > 0 }
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline, correctComicIDs.count > 0 else { return }
        
        let publishers = correctComicIDs.map {
            APIService.shared.getAPIResponseMapper(modelObject: Comic.self, endpoint: .comicByID(id: $0)) }
        print(publishers.count)
        
        let result = publishers.dropFirst().reduce(into: AnyPublisher(publishers[0].map{[$0]})) {
            res, just in
            res = res.zip(just) {
                i1, i2 -> [Comic] in
                return i1 + [i2]
            }.eraseToAnyPublisher()
        }
        
        self.cancellable = result
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                print("Success")
            }
        }, receiveValue: {
            self.comicsList += $0.sorted { $0.id > $1.id }
            if self.comicsList.last?.id == 1 {
                self.continueLoadingComics = false
            }
        })
    }
    
    // MARK: - Load details of a comic including the image and explanation
    func loadComicDetails(comic: Comic) {
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline else { return }
        
        cancellable = APIService.shared.getImageFetcher(imageUrl: comic.imageURL)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Success")
                }
            }, receiveValue: {_ in
//                self.comicDetails = com
            })
    }
    
    // MARK: - Search for comics using a search term of comic ID
    func searchComics(name: String) {
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline else { return }
        
        self.searchResults = []
        var comicIDs: [Int] = []
        
        if let comicID = Int(name) { comicIDs.append(comicID) }
        
        cancellable = APIService.shared.getAPIResponseMapper(modelObject: String.self, baseURL: APIService.comicSearchBaseURL, endpoint: .search(name: name))
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Success")
                }
            }, receiveValue: {
                comicIDs = comicIDs + $0.split(separator: "\n").compactMap { Int($0.split(separator: " ").first!) }.filter { $0 != 0 }
                self.loadComicsWith(comicIDs: comicIDs)
            })
    }
    
    // MARK: - Private Methods
    
    
}
