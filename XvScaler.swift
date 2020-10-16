//
//  XvScaler.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

struct XvScaleRange {
    
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

public class XvScaler {
    
    //MARK: - VARS
    
    fileprivate var inputRange:XvScaleRange
    fileprivate var outputRange:XvScaleRange
    
    //MARK: - INIT
    public init(inputRange:[Double], outputRange:[Double]) {
        
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
        self.inputRange = XvScaleRange(low: inputRange[0], high: inputRange[1])
        self.outputRange = XvScaleRange(low: outputRange[0], high: outputRange[1])
        
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

        return((outputRange.range * value) / inputRange.range) + outputRange.low
    }
    
    public func scale(value:CGFloat) -> CGFloat {
        
        return CGFloat(scale(value: Double(value)))

    }
    
    //optional so values are confirmed to be 0-255
    public func scale(value:UInt8) -> UInt8? {
        
        //if within range...
        if (inputRange.high <= 255.0 &&
                inputRange.low >= 0.0 &&
                outputRange.high <= 255.0 &&
                outputRange.low >= 0.0
        ) {
            
            return UInt8(scale(value: Double(value)))
            
        } else {
            print("XvScaler: Error: UInt8 input or output ranges invalid.")
            return nil
        }
    }
    
    public class func scale(dataSet:[Double], toScale:Double) -> [Double]? {
        
        //grab min and max
        if let min:Double = dataSet.min(),
           let max:Double = dataSet.max()
        {

            //get range
            let range:Double = max - min
        
            //scale to range and return
            return dataSet.map { (($0-min) * toScale) / range }
            
        } else {
            print("XvScaler: Error: Unable to get min or max from data set", dataSet)
            return nil
        }
    }
}
