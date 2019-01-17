//
//  Endpoint.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


/// Generic REST API endpoint.
protocol Endpoint {
    /// The base of the URL.
    var base: String { get }
    /// The root path of the URL.
    var rootPath: String { get }
    /// The path of the URL.
    var path: String { get }
    /// The query items of the URL.
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    /// Get the URL components comprised of base, rootPath, path, and queryItems.
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    /// Get the URL request created from urlComponents.
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
