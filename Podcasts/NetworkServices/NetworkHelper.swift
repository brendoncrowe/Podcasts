//
//  NetworkHelper.swift
//  Podcasts
//
//  Created by Brendon Crowe on 1/25/23.
//

import Foundation

enum AppError: Error {
    case badURL(String) // associated value
    case noResponse
    case networkClientError(Error) // no internet connection
    case noData
    case decodingError(Error)
    case badStatusCode(Int) // 404, 500
    case badMimeType(String) // image/jpg
}

class NetworkHelper {
    
    // we will create a shared instance of the NetworkHelper
    static let shared = NetworkHelper()
    
    private var session: URLSession
    
    // we will make the default initializer private
    // required in order to be considered a singleton
    // also forbids anyone from creating an instance of NetworkHelper
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(with request: URLRequest,
                         completion: @escaping (Result<Data, AppError>) -> ()) {
        
        // YOU MUST START WITH A DATATASK
    
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // 1. deal with error if any
            // check for client network errors
            if let error = error {
                completion(.failure(.networkClientError(error)))
            }
            
            // 2. downcast URLResponse (response) to HTTPURLResponse to
            //    get access to the statusCode property on HTTPURLResponse
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            // 3. unwrap the data object
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // 4. validate that the status code is in the 200 range otherwise it's a
            //    bad status code
            switch urlResponse.statusCode {
            case 200...299: break // everything went well here
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
                return
            }
            
            // 5. capture data as success case
            completion(.success(data))
        }
        dataTask.resume()
        
    }
    
}
