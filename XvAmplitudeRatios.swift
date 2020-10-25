//
//  XvVelocityProcessor.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/11/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation

/*
 Pass in an array of values
 Get back an array of percentages of the array's max
 */
public class XvAmplitudeRatios {
    
    public func compare(amplitudes:[Double]) -> [Double]? {
        
        if let max:Double = amplitudes.max() {
            
            var percentages:[Double] = []
            
            for amp in amplitudes {
                percentages.append(amp / max)
            }
            
            return percentages
        
        } else {
            return nil //probably a blank array was passed in
        }
    }
    
}
