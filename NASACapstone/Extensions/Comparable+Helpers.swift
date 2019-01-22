//
//  Comparable+Helpers.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/21/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

extension Comparable {
    /**
     Get the value clamped to a lower and upper bound.
     
     - Parameter limits: The upper and lower bounds.
     - Returns: The clamped value.
    */
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
