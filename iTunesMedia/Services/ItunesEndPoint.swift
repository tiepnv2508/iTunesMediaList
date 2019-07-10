//
//  ItunesEndPoint.swift
//  iTunesMedia
//
//  Created by Kaka on 7/10/19.
//  Copyright © 2019 Tiep Nguyen. All rights reserved.
//

import Foundation

enum ItunesEndPoint {
    case media(type: MediaType)
}

enum MediaType: String{
    case appleMusic = "apple-music/top-songs/all/25/explicit.json"
    case itunesMusic = "itunes-music/top-songs/all/25/explicit.json"
    case iosApps = "ios-apps/top-free/all/25/explicit.json"
    case audiobooks = "audiobooks/top-audiobooks/all/25/explicit.json"
    case books = "books/top-free/all/25/explicit.json"
    case tvShows = "tv-shows/top-tv-episodes/all/25/explicit.json"
    case movies = "movies/top-movies/all/25/explicit.json"
    case itunesU = "itunes-u/top-itunes-u-courses/all/25/explicit.json"
    case podcasts = "podcasts/top-podcasts/all/25/explicit.json"
    case musicVideos = "music-videos/top-music-videos/all/25/explicit.json"
}

extension ItunesEndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    func provideURL() -> URL {
        switch self {
        case .media(let type):
            return baseURL.appendingPathComponent(type.rawValue)
        }
    }
}
