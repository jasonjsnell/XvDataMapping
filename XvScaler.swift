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
    }
}

public class XvScaler {
    
    //MARK: - VARS
    
    fileprivate var _inputRange:XvScaleRange
    public var inputRange:[Double] {
        get { return [_inputRange.low, _inputRange.high] }
        set {
            if (newValue.count != 2) { //error checking
                print("XvScaler: Error: inputRange needs 2 values")
                fatalError()
            }
            _inputRange = XvScaleRange(low: newValue[0], high: newValue[1])
        }
    }
    fileprivate var _outputRange:XvScaleRange
    public var outputRange:[Double] {
        get { return [_outputRange.low, _outputRange.high] }
        set {
            if (newValue.count != 2) { //error checking
                print("XvScaler: Error: outputRange needs 2 values")
                fatalError()
            }
            _outputRange = XvScaleRange(low: newValue[0], high: newValue[1])
        }
    }
    
    //MARK: - INIT
    public init(inputRange:[Double] = [0, 1], outputRange:[Double] = [0,1]) {
        
        //error checking
        //make sure input and output range arrays are only 2 characters,
        if (inputRange.count != 2 || outputRange.count != 2) {
            print("XvScaler: Error: inputRange and outputRange each need 2 values for init")
            fatalError()
        }
        
        //init double range
        self._inputRange = XvScaleRange(low: inputRange[0], high: inputRange[1])
        self._outputRange = XvScaleRange(low: outputRange[0], high: outputRange[1])
    }
    
    //MARK: - SCALE
    public func scale(value:Double) -> Double {
        
        print("output range", _outputRange.range, "x value", value, "/ input range", _inputRange.range, "+ output low", _outputRange.low, "=", ((_outputRange.range * value) / _inputRange.range) + _outputRange.low)
        return ((_outputRange.range * value) / _inputRange.range) + _outputRange.low
    }
    
    //flips the input and output ranges
    public func reverseScale(value:Double) -> Double {
        
        return ((value - _outputRange.low) / _outputRange.range) * _inputRange.range
    }
    
    public func scale(value:CGFloat) -> CGFloat {
        
        return CGFloat(scale(value: Double(value)))
    }
    
    //optional so values are confirmed to be 0-255
    public func scale(value:UInt8) -> UInt8? {
        
        //if within range...
        if (
            _inputRange.high <= 255.0 &&
            _inputRange.low >= 0.0 &&
            _outputRange.high <= 255.0 &&
            _outputRange.low >= 0.0
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

/*
 
 Example
 
 inputRangeLow    0.0 - 1.0
 inputRangeHigh   0.0 - 1.0
 outputRangeLow   64  - 0
 outputRangeHigh  64-127
 
 */

/*
public class XvLogarithmicScaler {
    
    fileprivate let _ratio:XvRatio
    
    fileprivate var inputRangeLow:XvScaleRange
    fileprivate var inputRangeHigh:XvScaleRange
    fileprivate var outputRangeLow:XvScaleRange
    fileprivate var outputRangeHigh:XvScaleRange
    
    //MARK: - INIT
    public init(
        inputRangeLow:[Double],
        inputRangeHigh:[Double],
        outputRangeLow:[Double],
        outputRangeHigh:[Double]
    ) {
        
        //error checking
        //make sure input and output range arrays are only 2 characters,
        if (
            inputRangeLow.count != 2 ||
            inputRangeHigh.count != 2 ||
            outputRangeLow.count != 2 ||
            outputRangeHigh.count != 2
        ) {
            print("XvScaler: Error: inputRange and outputRange each need 2 values for init")
            fatalError()
        }
        
        //init double range
        self.inputRangeLow = XvScaleRange(low: inputRangeLow[0], high: inputRangeLow[1])
        self.inputRangeHigh = XvScaleRange(low: inputRangeHigh[0], high: inputRangeHigh[1])
        self.outputRangeLow = XvScaleRange(low: outputRangeLow[0], high: outputRangeLow[1])
        self.outputRangeHigh = XvScaleRange(low: outputRangeHigh[0], high: outputRangeHigh[1])
        
        self._ratio = XvRatio()
    }
    
    //MARK: - SCALE
    public func scale(values:[Double]) -> Double? {

        if let ratio:Double = _ratio.getRatio(from: values) {
            
            print("ratio", ratio)
        }
        
        return nil
        //return((outputRange.range * value) / inputRange.range) + outputRange.low
    }
    
}
*/
