//
//  ItunesServices.swift
//  iTunesMedia
//
//  Created by Kaka on 7/10/19.
//  Copyright © 2019 Tiep Nguyen. All rights reserved.
//

import Foundation

class ItunesServices {
    public static let shared = ItunesServices()
    private init() {}
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                //If success, we retrieve the data then check the response HTTP status code
                //to make sure it’s in the range between 200 and 299
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponse))
                    }
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(values))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodeError))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.customError(error.localizedDescription)))
                }
            }
            }.resume()
    }
    
    //****************************************************
    //* Fetch Itunes Media List
    //* Params: mediaType
    //* Return values: MediaResponse
    //****************************************************
    public func fetchItunesMedia(mediaType: MediaType, result: @escaping (Result<MediaResponse, APIServiceError>) -> Void) {
        let url = ItunesEndPoint.media(type: mediaType).provideURL()
        fetchResources(url: url, completion: result)
    }
}
