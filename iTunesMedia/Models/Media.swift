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
