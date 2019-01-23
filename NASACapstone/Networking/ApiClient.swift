//
//  NasaApiClient.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/16/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


/// Error related to the REST API.
enum ApiError: Error {
    /// The request failed.
    case requestFailed
    /// The response did not have a success status code.
    case responseUnsuccessful
    /// Something is wrong with the response data.
    case invalidData
}


/// Result of an API client request.
enum ApiResponse<T> {
    /// The success case with the resulting value.
    case success(result: T)
    /// The failure case with the error describing the failure.
    case failure(error: Error)
}


/// A generic REST API client.
class ApiClient {
    /// The API key used for authentication.
    let apiKey: String
    /// The session that will make the requests.
    let session: URLSession
    /// The decoder for fetched results.
    let decoder: JSONDecoder
    
    /**
     Initialize the client.
     
     - Parameter apiKey: The API key used for authentication.
     - Parameter session: The URL session to use. If nil, A new session is created using the .ephemeral configuration.
    */
    init(apiKey: String, session: URLSession? = nil) {
        self.apiKey = apiKey
        self.session = session ?? URLSession(configuration: .ephemeral)
        // Setup decoder
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(NasaApi.dateFormatter)
    }
    
    /**
     Make a generic fetch request to the API.
     
     - Parameter request: The request to make.
     - Parameter completionHandler: Called with the results when the request has finished.
    */
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (ApiResponse<T>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for error
            if let error = error {
                completion(.failure(error: error))
                return
            }
            
            // Cast URLResponse to HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(error: ApiError.requestFailed))
                return
            }
            
            // Check response status code is success
            guard httpResponse.statusCode == 200 else {
                completion(.failure(error: ApiError.responseUnsuccessful))
                return
            }
            
            // Check data exists
            guard let data = data else {
                completion(.failure(error: ApiError.invalidData))
                return
            }
            
            // Try to decode JSON response to model
            do {
                //let json = try JSONSerialization.jsonObject(with: data, options: [])
                let model = try self.decoder.decode(T.self, from: data)
                completion(.success(result: model))
            } catch {
                completion(.failure(error: error))
            }
        }
        task.resume()
    }
}
