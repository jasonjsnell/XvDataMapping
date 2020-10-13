//
//  XvMidiCC.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/12/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation


public class XvMidiCC {
    
    public let name:String
    
    fileprivate let controller:UInt8
    fileprivate let min:UInt8
    fileprivate let max:UInt8
    
    fileprivate let midiRangeAttn:XvAttenuator = XvAttenuator(min: 0, max: 127)
    fileprivate let scaler:XvScaler
    
    public init(controller:UInt8, min:UInt8, max:UInt8, name:String = "") {
        
        self.controller = controller
        
        //make sure incoming min is within midi range
        self.min = midiRangeAttn.attenuate(value: min)
        
        //same with max
        self.max = midiRangeAttn.attenuate(value: max)
        
        
        scaler = XvScaler(
            inputRange: [0.0, 1.0],
            outputRange: [Double(self.min), Double(self.max)]
        )
        
        //if user passes in a name
        //used for convenience
        self.name = name
        
    }
    
    
    public func getCC(from percentage:Double) -> UInt8? {
        
        if let cc:UInt8 = scaler.scaleToUInt8(double: percentage) {
            return cc
        } else {
            print("XvMidiCC: Error: Unable to convert percent to cc")
            return nil
        }
    }
}

