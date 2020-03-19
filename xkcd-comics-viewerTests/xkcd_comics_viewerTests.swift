//
//  xkcd_comics_viewerTests.swift
//  xkcd-comics-viewerTests
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import XCTest
@testable import xkcd_comics_viewer

class xkcd_comics_viewerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLatestComicLoad() {
        let promise = expectation(description: "latest comic loaded")
        
        let cancellable = APIService.shared.getAPIResponseMapper(modelObject: Comic.self, endpoint: .latest)
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                promise.fulfill()
            }
        }, receiveValue: {_ in
        })
        
        wait(for: [promise], timeout: 5)
    }
    
    func testComicRetrievalByID() {
        let comicID = 1
        
        let promise = expectation(description: "Comic 1 loaded")
        let cancellable = APIService.shared.getAPIResponseMapper(modelObject: Comic.self, endpoint: .comicByID(id: comicID))
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                promise.fulfill()
            }
        }, receiveValue: {_ in
            
        })
        
        wait(for: [promise], timeout: 5)
    }
    
    func testComicsSearch() {
        let searchTerm = "45"
        
        let promise = expectation(description: "Comic Search Completed")
        let cancellable = APIService.shared.getAPIStringResponseMapper(baseURL: APIService.comicSearchBaseURL, endpoint: .search(name: searchTerm))
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                promise.fulfill()
            }
        }, receiveValue: {_ in
            
        })
        
        wait(for: [promise], timeout: 5)
    }
}
