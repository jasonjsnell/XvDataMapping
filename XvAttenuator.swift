//
//  XvAttenuator.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//keeps a value within the specified range via attenuation (clipping it, as opposed to scaling)

public class XvAttenuator {
    
    //values are passed in as Double
   
    fileprivate var min:Double
    fileprivate var max:Double
    
    //MARK: - Init
    public init(min:Double, max:Double) {
        
        if (min >= max) {
            print("XvAttenuator: Error: min value must be less than max value")
            fatalError()
        }
        
        //init default, which is double
        self.min = min
        self.max = max
        
    }
    
    
    //MARK: - Attenuate
    public func attenuate(value:Double) -> Double {
        
        var newValue:Double = value
        if (newValue.isNaN || newValue.isInfinite) { newValue = 0 }
        newValue = Double(Int(newValue * 100000)) / 100000
        
        //attenuate
        if (newValue > max) {
            return max
        } else if (newValue < min) {
            return min
        } else {
            return newValue
        }
    }
    
    public func attenuate(value:CGFloat) -> CGFloat {
        
        return CGFloat(attenuate(value: Double(value)))
    }
    
    public func attenuate(value:Int) -> Int {
        
        return Int(attenuate(value: Double(value)))
    }
    
    public func attenuate(value:UInt8) -> UInt8 {
        
        return UInt8(attenuate(value: Double(value)))
    }
}
