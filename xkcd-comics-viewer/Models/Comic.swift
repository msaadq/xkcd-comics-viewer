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
    
    var publishedDate: Date?
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
    static func loadSampleComic() -> Comic? {
        let sampleComic = """
        {
            "month": "7",
            "num": 614,
            "link": "",
            "year": "2009",
            "news": "",
            "safe_title": "Woodpecker",
            "transcript": "[[A man with a beret and a woman are standing on a boardwalk, leaning on a handrail.]]\nMan: A woodpecker!\n<<Pop pop pop>>\nWoman: Yup.\n\n[[The woodpecker is banging its head against a tree.]]\nWoman: He hatched about this time last year.\n<<Pop pop pop pop>>\n\n[[The woman walks away.  The man is still standing at the handrail.]]\n\nMan: ... woodpecker?\nMan: It's your birthday!\n\nMan: Did you know?\n\nMan: Did... did nobody tell you?\n\n[[The man stands, looking.]]\n\n[[The man walks away.]]\n\n[[There is a tree.]]\n\n[[The man approaches the tree with a present in a box, tied up with ribbon.]]\n\n[[The man sets the present down at the base of the tree and looks up.]]\n\n[[The man walks away.]]\n\n[[The present is sitting at the bottom of the tree.]]\n\n[[The woodpecker looks down at the present.]]\n\n[[The woodpecker sits on the present.]]\n\n[[The woodpecker pulls on the ribbon tying the present closed.]]\n\n((full width panel))\n[[The woodpecker is flying, with an electric drill dangling from its feet, held by the cord.]]\n\n{{Title text: If you don't have an extension cord I can get that too.  Because we're friends!  Right?}}",
            "alt": "If you don't have an extension cord I can get that too.  Because we're friends!  Right?",
            "img": "https://imgs.xkcd.com/comics/woodpecker.png",
            "title": "Woodpecker",
            "day": "24"
        }
        """

        if let jsonData = sampleComic.data(using: .utf8) {
            do {
                let response = try JSONDecoder().decode(Comic.self, from: jsonData)
                return response
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
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
    }
}
