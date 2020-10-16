//
//  XvGate.swift
//  XvDataMapping
//
//  Created by Jason Snell on 10/15/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation
import Accelerate

/*
 let gate:XvGate = XvGate(threshold:20)
 gate.attenuate(signal: mySignalValue)
 
 
 */
public class XvGate {
    
    fileprivate var _threshold:Double = 0.0
    public var threshold:Double {
        get { return _threshold }
        set { _threshold = newValue }
    }
    
    public init(threshold:Double){
        self.threshold = threshold
    }
    
    //single digit
    public func attenuate(signal:Double) -> Double {
        
        if (signal < threshold) {
            return 0
        } else {
            return signal
        }
    }
    
    //array of values
    public func attenuate(signal:[Double]) -> [Double] {
        
        var gatedSignal:[Double] = signal
        //Remove the noise from the signal by zeroing all values in the frequency domain data that are below a specified threshold.
        vDSP.threshold(signal,
            to: threshold,
            with: .zeroFill,
            result: &gatedSignal)
        
        return gatedSignal
    }
    
    
}
