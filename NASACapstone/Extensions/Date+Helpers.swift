//
//  Date+Helpers.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

extension Date {
    /// Get the first day of the month from this Date.
    var firstDayOfTheMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        let result = Calendar.current.date(from: components)!
        return result
    }
    
    /// Get the last day of the month from this Date.
    var lastDayOfTheMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        let result = Calendar.current.date(byAdding: components, to: firstDayOfTheMonth)!
        return result
    }
}
