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
   
    fileprivate var minD:Double
    fileprivate var maxD:Double
    
    fileprivate var minCG:CGFloat
    fileprivate var maxCG:CGFloat
    
    //optional to confirm values are 0-255
    fileprivate var minU:UInt8?
    fileprivate var maxU:UInt8?
    
    //MARK: - Init
    public init(min:Double, max:Double) {
        
        if (min >= max) {
            print("XvAttenuator: Error: min value must be less than max value")
            fatalError()
        }
        
        //init default, which is double
        minD = min
        maxD = max
        
        //init CG
        minCG = CGFloat(min)
        maxCG = CGFloat(max)
        
        //if 0-255, init UInt8
        if (min >= 0.0 && min <= 255.0 && max >= 0.0 && max <= 255.0) {
            minU = UInt8(min)
            maxU = UInt8(max)
        }
        
    }
    
    
    //MARK: - Attenuate
    public func attenuate(value:Double) -> Double {
        
        let newValue:Double = Double(Int(value * 100000)) / 100000
        
        //attenuate
        if (newValue > maxD) {
            return maxD
        } else if (newValue < minD) {
            return minD
        } else {
            return newValue
        }
    }
    
    public func attenuate(value:CGFloat) -> CGFloat {
        
        if (value > maxCG) {
            return maxCG
        } else if (value < minCG) {
            return minCG
        } else {
            return value
        }
    }
    
    
    public func attenuate(value:UInt8) -> UInt8? {
        
        //init uint8 range
        if (minU != nil && maxU != nil) {
            
            //attenuate
            if (value > maxU!) {
                return maxU!
            } else if (value < minU!) {
                return minU!
            } else {
                return value
            }
            
        } else {
            print("XvAttenuator: Error: minU or maxU are invalid")
            return nil
        }
    }
}
