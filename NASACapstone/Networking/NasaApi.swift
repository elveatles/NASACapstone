//
//  NasaApi.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


/// NASA REST API related configuration.
struct NasaApi {
    /// Date formatting for the REST API.
    static var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd"
        return result
    }()
}
