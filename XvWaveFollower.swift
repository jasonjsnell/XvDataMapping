//
//  XvWaveFollower.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//


/*
 
 In: Wave history
 Desc: Follows the up and down of the waves precisely.
 Out: Current percent of wave max, 0.0-1.0
 
 */

import UIKit

public class XvWaveFollower {
    
    fileprivate var bandwidthD:Double = 1.0
    fileprivate var bandwidthCG:CGFloat = 1.0
    
    public init(){}
    
    //pass in array of wave history data
    public func update(with waveHistory:[Double]) -> Double? {
        
        if let highest:Double = waveHistory.max(),
            let current:Double = waveHistory.last {
                
            //get pct, returns 0.0-1.0 value
            return current/highest
            
        } else {
            print("XvWaveFollower: Error: Unable to get min, max, last from incoming data.")
            //if array is blank, return nil
            return nil
        }
        
    }
}
