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
    @Published var searchResults: [Comic] = []
    @Published var connectionOnline = true
    
    var cancellable: AnyCancellable?
    
    private var latestComicID: Int!
    private static let defaultComicsCount: Int = 20
    
    // MARK: - Public API
    
    // MARK: - Load latest comic with additional recent comics
    func loadLatestComic(additionalCount: Int = defaultComicsCount) {
        assert(additionalCount >= 0)
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline else { return }
        
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
                self.comicsList.append($0)
                self.latestComicID = $0.id
                self.loadComicsFrom(comicID: self.latestComicID, count: additionalCount)
            })
    }
    
    // MARK: - load additional recent comics starting from a comic position
    func loadComicsFrom(comicID: Int, count: Int = defaultComicsCount) {
        assert(comicID > 0 && count > 0)
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline else { return }
        
        cancellable = APIService.shared.getAPIResponseMapper(modelObject: Comic.self, endpoint: .comicByID(id: comicID))
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Success")
                }
            }, receiveValue: {
                self.comicsList.append($0)
                if  count != 0 { self.loadComicsFrom(comicID: comicID - 1, count: count - 1)}
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
    
    // MARK: - Search for comics using a search term of comic ID
    private func loadComicsWith(comicIDs: [Int]) {
        var correctComicIDs = comicIDs.filter { $0 <= latestComicID && $0 > 0 }
        assert(correctComicIDs.count > 0)
        connectionOnline = Reachability.isConnectedToNetwork()
        guard connectionOnline else { return }
        
        cancellable = APIService.shared.getAPIResponseMapper(modelObject: Comic.self, endpoint: .comicByID(id: correctComicIDs.first!))
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Success")
                }
            }, receiveValue: {
                correctComicIDs.remove(at: 0)
                self.searchResults.append($0)
                self.loadComicsWith(comicIDs: correctComicIDs)
            })
    }
}
