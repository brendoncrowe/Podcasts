//
//  PodcastAPIClient.swift
//  Podcasts
//
//  Created by Brendon Crowe on 1/25/23.
//

import Foundation


struct PodcastAPIClient {
    
    static func getPodcasts(searchQuery: String, completion: @escaping (Result<[Podcast], AppError>) -> ()) {
        
        let apiEndpoint =  "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        
        guard let url = URL(string: apiEndpoint) else {
            completion(.failure(.badURL(apiEndpoint)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let podcasts = results.results
                    completion(.success(podcasts))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    
    static func fetchFavoritePodcasts(completion: @escaping (Result<[Podcast], AppError>) -> ()) {
        
    }
}
