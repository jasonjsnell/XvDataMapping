//
//  XvScaler.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

struct XvScaleRangeD {
    
    var low:Double
    var high:Double
    var range:Double
    
    init (low:Double, high:Double) {
        self.low = low
        self.high = high
        self.range = high-low
        if (range <= 0.0) {
            print("XvScaleRangeD: Error: Low value in range must be less than high value.")
            fatalError()
        }
    }
}

struct XvScaleRangeCG {
    
    var low:CGFloat
    var high:CGFloat
    var range:CGFloat
    
    init (low:CGFloat, high:CGFloat) {
        self.low = low
        self.high = high
        self.range = high-low
        if (range <= 0.0) {
            print("XvScaleRangeCG: Error: Low value in range must be less than high value.")
            fatalError()
        }
    }
}

struct XvScaleRangeU {
    
    var low:UInt8
    var high:UInt8
    var range:UInt8
    
    init (low:UInt8, high:UInt8) {
        self.low = low
        self.high = high
        self.range = high-low
        
        if (range <= 0) {
            print("XvScaleRangeU: Error: Low value", low, "in range must be less than high value", high)
            fatalError()
        }
    }
}



public class XvScaler {
    
    //MARK: - VARS
    
    fileprivate var inputRange:[Double]
    fileprivate var outputRange:[Double]
    
    fileprivate var inputRangeD:XvScaleRangeD
    fileprivate var outputRangeD:XvScaleRangeD
    
    fileprivate var inputRangeCG:XvScaleRangeCG
    fileprivate var outputRangeCG:XvScaleRangeCG
    
    fileprivate var inputRangeU:XvScaleRangeU?
    fileprivate var outputRangeU:XvScaleRangeU?
    
    //MARK: - INIT
    public init(inputRange:[Double], outputRange:[Double]) {
        
        self.inputRange = inputRange
        self.outputRange = outputRange
        
        //error checking
        //make sure input and output range arrays are only 2 characters,
        if (inputRange.count != 2 || outputRange.count != 2) {
            print("XvScaler: Error: inputRange and outputRange each need 2 values for init")
            fatalError()
        }
            
        //confirm format as [lowValue, highValue]
        if (inputRange[0] >= inputRange[1] || outputRange[0] >= outputRange[1]) {
            
            print("XvScaler: Error: inputRange and inputRange each need to be formatted [lowValue, highValue")
            fatalError()
        }
        
        //init double range
        inputRangeD = XvScaleRangeD(low: inputRange[0], high: inputRange[1])
        outputRangeD = XvScaleRangeD(low: outputRange[0], high: outputRange[1])
        
        //init CG too
        inputRangeCG = XvScaleRangeCG(low: CGFloat(inputRange[0]), high: CGFloat(inputRange[1]))
        outputRangeCG = XvScaleRangeCG(low: CGFloat(outputRange[0]), high: CGFloat(outputRange[1]))
        
        //if ranges can work for UInt8 (0-255), then init UInt8
        
        if (inputRange[0] >= 0.0 && inputRange[1] <= 255.0) {
            
            //turn into UInt8's and compare again to make sure both aren't the same value
            let inputHigh:UInt8 = UInt8(inputRange[0])
            let inputLow:UInt8 = UInt8(inputRange[1])
            
            if (inputLow < inputHigh) {
                inputRangeU = XvScaleRangeU(low: inputLow, high: inputHigh)
            }
        }
        
        if (outputRange[0] >= 0.0 && outputRange[1] <= 255.0) {
            
            //turn into UInt8's and compare again to make sure both aren't the same value
            let outputHigh:UInt8 = UInt8(outputRange[0])
            let outputLow:UInt8 = UInt8(outputRange[1])
            
            if (outputLow < outputHigh) {
                outputRangeU = XvScaleRangeU(low: outputLow, high: outputHigh)
            }
        }
    }

    
    //MARK: - SCALE
    //scaleToUInt8(double:Double)
    //scaleToDouble(double:Double)
    //scaleToCGFloat(double:Double)
    
    //input Double, return UInt8
    public func scaleToUInt8(double:Double) -> UInt8? {
        
        print("NEED TO CODE: XvScaler: scaleToUInt8")
        
        return nil
        
        /*
        if (inputRangeD != nil){
            
        } else {
            print("XvScaler: Error: Double input range is invalid.")
            return nil
        }
        
        return 0*/
    }
    
    public func scale(value:Double) -> Double {

        return((outputRangeD.range * value) / inputRangeD.range) + outputRangeD.low
    }
    
    public func scale(value:CGFloat) -> CGFloat {

        return((outputRangeCG.range * value) / inputRangeCG.range) + outputRangeCG.low
    }
    
    //optional so values are confirmed to be 0-255
    public func scale(value:UInt8) -> UInt8? {
        
        if (inputRangeU != nil && outputRangeU != nil) {
            
            return((outputRangeU!.range * value) / inputRangeU!.range) + outputRangeU!.low
            
        } else {
            print("XvScaler: Error: UInt8 input or output ranges invalid.")
            return nil
        }
    }
}
