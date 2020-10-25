//
//  XvRatio.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/14/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation

public class XvRatio {
    
    /*
     
     Pass in two wave magnitudes (values that are above zero)
     Returns positive value if first wave is dominant, and by what percent
     Returns negative value if first wave is submissive, and by what percent
     
     Ex: alphaDeltaRatio
     -0.3 means alpha is submissive to delta by 30%
     2.0 means alpha is dominant over delta by 200%
     
     */
    
    public class func getRatio(from values:[Double]) -> Double? {
        
        if (values.count == 2) {
            
            return (values[0] / values[1]) - 1.0
            
        } else {
            
            print("XvRatio: Error: 2 values need to be passed in to calc a ratio")
            return nil
        }
    }
}
