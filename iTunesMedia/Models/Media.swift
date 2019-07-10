//
//  Media.swift
//  iTunesMedia
//
//  Created by Kaka on 7/10/19.
//  Copyright © 2019 Tiep Nguyen. All rights reserved.
//

import Foundation

struct Media: Decodable {
    let name: String
    let kind: String
    let imgUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case name, kind, imgUrl = "artworkUrl100"
    }
}

struct MediaResponse: Decodable {
    enum RootKeys: String, CodingKey {
        case feed
    }
    
    enum FeedKeys: String, CodingKey {
        case results
    }
    
    var results = [Media]()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let feedContainer = try container.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
        results = try feedContainer.decode([Media].self, forKey: .results)
    }
}
