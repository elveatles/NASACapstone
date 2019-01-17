//
//  MockURLSession.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/16/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}


class MockURLSession: URLSession {
    typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var mockDataTaskResponse: (Data?, URLResponse?, Error?) = (nil, nil, URLError(URLError.Code.cancelled))
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        return MockURLSessionDataTask(closure: {
            completionHandler(
                self.mockDataTaskResponse.0,
                self.mockDataTaskResponse.1,
                self.mockDataTaskResponse.2)
        })
    }
}
