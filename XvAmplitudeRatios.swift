//
//  XvVelocityProcessor.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/11/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation

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
