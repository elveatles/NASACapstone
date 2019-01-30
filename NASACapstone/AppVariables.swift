//
//  AppVariables.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/30/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation
import CoreLocation

/// Variables that can be used throughout the app.
struct AppVariables {
    /// Singleton instance.
    static let shared = AppVariables()
    
    /// Ephemeral (no-caching) URL session.
    let urlSession = URLSession(configuration: .ephemeral)
}
