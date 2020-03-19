//
//  Comic.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 15/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Comic
struct Comic: Hashable, Codable, Identifiable {
    let id, month, year, day: Int
    let link, news, safeTitle, transcript, alt, title: String
    let imageURL: URL
    let publishedDate: Date!
    
    var image: UIImage?

    enum CodingKeys: String, CodingKey {
        case month, link, year, news, transcript, alt, title, day
        case imageURL = "img"
        case id = "num"
        case safeTitle = "safe_title"
    }
}

// MARK: - Sample Comic loader and custom decoding
extension Comic {
    static func loadSampleComic() -> [Comic] {
        return APIService.shared.loadSampleResource("SampleComics.json")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.day = try Int(container.decode(String.self, forKey: .day))!
        self.month = try Int(container.decode(String.self, forKey: .month))!
        self.year = try Int(container.decode(String.self, forKey: .year))!
        self.link = try container.decode(String.self, forKey: .link)
        self.news = try container.decode(String.self, forKey: .news)
        self.safeTitle = try container.decode(String.self, forKey: .safeTitle)
        self.transcript = try container.decode(String.self, forKey: .transcript)
        self.alt = try container.decode(String.self, forKey: .alt)
        self.imageURL = try URL(string: container.decode(String.self, forKey: .imageURL))!
        self.title = try container.decode(String.self, forKey: .title)
        
        self.publishedDate = DateComponents.dateFrom(day: self.day, month: self.month, year: self.year)
    }
}
