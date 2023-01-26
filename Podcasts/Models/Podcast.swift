//
//  Podcast.swift
//  Podcasts
//
//  Created by Brendon Crowe on 1/25/23.
//

import Foundation

struct PodcastSearch: Decodable {
    let results: [Podcast]
}

struct Podcast: Decodable {
        let trackId: Int
        let artworkUrl600: String
        let collectionName: String
        let primaryGenreName: String?
        let artistName: String?
        let favoritedBy: String?
}
