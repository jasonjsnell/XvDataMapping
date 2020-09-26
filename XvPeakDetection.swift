//
//  XvPeakDetection.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

public class XvPeakDetection {
    
    fileprivate var thresholdD:Double = 0.0
    fileprivate var thresholdCG:CGFloat = 0.0
    

    public init(threshold:Any) {
        
        if let d = threshold as? Double {
            thresholdD = d
           
        } else if let cg = threshold as? CGFloat {
            thresholdCG  = cg
            
        } else {
            print("XvPeakDetection: Error: Type not found, threshold not set.")
        }
    }
    
    public func check(value:Double) -> Bool {
        if (value > thresholdD) {
            return true
        } else {
            return false
        }
    }
    
    public func check(value:CGFloat) -> Bool {
        if (value > thresholdCG) {
            return true
        } else {
            return false
        }
    }
    
}
