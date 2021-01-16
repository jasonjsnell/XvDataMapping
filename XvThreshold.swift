//
//  XvThreshold.swift
//  XvDataMapping
//
//  Created by Jason Snell on 1/14/21.
//  Copyright © 2021 Jason Snell. All rights reserved.
//

import Foundation

public class XvThreshold {

    //changeable
    public var max:Double
    public var threshold:Double
    
    fileprivate var _above:Double = 0
    fileprivate var _below:Double = 0
    
    //accessors
    public var above:Double {
        get {
            return _above
        }
    }
    public var below:Double {
        get {
            return _below
        }
    }
    
    public init(threshold:Double, max:Double = 1.0) {
        
        self.threshold = threshold
        self.max = max
    }
    
    public func process(signal:Double) -> Double {
        
        if (signal > threshold) {
            _above = signal-threshold
            _below = 0
        
        } else if (signal < threshold) {
            _above = 0
            _below = threshold-signal
        
        } else if (signal == threshold) {
            _above = 0
            _below = 0
        }
        
        /*
         max = 1.0
         threshold = 0.7
         signal = 0.9
         
         above = 0.2
         
         */
        //return percent amount above the threshold
        return above / (max-threshold)
    }
}
