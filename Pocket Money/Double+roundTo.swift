//
//  Double+roundTo.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/2/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import Foundation

extension Double {
    
    func roundTo(places: Int) -> Double {
        let tenToPower = pow(10.0, Double((places >= 0 ? places : 0)))
        let roundedValue = (self * tenToPower).rounded() / tenToPower
        return roundedValue
    }
}
