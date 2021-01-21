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
    fileprivate var _value:Double = 0
    
    //accessors
    public var value:Double {
        get {
            return _value
        }
    }
    
    public init(threshold:Double, max:Double = 1.0) {
        
        self.threshold = threshold
        self.max = max
    }
    
    public func process(signal:Double) -> Double {
        
        if (signal > threshold) {
            _above = signal-threshold
            _value = _above
        
        } else if (signal < threshold) {
            _above = 0
            _value = signal-threshold //value is a negative value
        
        } else if (signal == threshold) {
            _above = 0
            _value = 0
        }
        
        //return percent amount above the threshold
        return _above / (max-threshold)
    }
}
