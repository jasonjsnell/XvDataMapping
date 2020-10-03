//
//  XvResistorClosed.swift
//  XvDataMapping
//
//  Created by Jason Snell on 10/1/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

/*
 
 This module slows down the rate of change of a changing variable, the way an electric resistor slows down a flow of electricity.
 
 The resistor can be set up with a tolerance (maximum current amount) and resistance value, which the flow is calculated. These metaphors mirror the electric circuit the most and can be helpful when using this object.
 
 Can accept Double, CGFloat
 */

import Foundation

public class XvResistorClosed:Resistor {
    
    //tolerance is the maximum value of the current
    fileprivate var _tolerance:Double
    
    //MARK: - upwards resistance
    public var _upwardsResistance:Double
    public var upwardsResistance:Double {
        
        get { return _upwardsResistance }
        set {
            
            //store locally
            _upwardsResistance = newValue
            
            //update increment in main class
            setIncrement(tolerance: _tolerance, resistance: _upwardsResistance)
        }
    }
    
    //MARK: - downwards resistance
    public var _downwardsResistance:Double
    public var downwardsResistance:Double {
        
        get { return _downwardsResistance }
        set {
            
            //store locally
            _downwardsResistance = newValue
            
            //update decrement in main class
            setDecrement(tolerance: _tolerance, resistance: _downwardsResistance)
        }
    }
    
    //MARK: - Init
    public override init(tolerance:Double, resistance:Double) {
        
        self._tolerance = tolerance
        self._upwardsResistance = resistance
        self._downwardsResistance = resistance
        
        super.init(tolerance: tolerance, resistance: resistance)
    }
    
    //same as above but can specify unique resistance for upwards flow or downwards flow
    public override init(tolerance:Double, upwardsResistance:Double, downwardsResistance:Double) {
        
        self._tolerance = tolerance
        self._upwardsResistance = upwardsResistance
        self._downwardsResistance = downwardsResistance
        
        super.init(tolerance: tolerance, upwardsResistance: upwardsResistance, downwardsResistance: downwardsResistance)
    }
    
    public override func applyResistance(toCurrent:Double) -> Double {
        
        //if there is no resistance...
        if (_upwardsResistance == 0.0 && _downwardsResistance == 0.0) {
            //return the unchanged current immediately
            return toCurrent
        }
        
        // if the incoming current is over the tolerance...
        if (toCurrent > _tolerance) {
            
            // ... then return the tolerance with an error
            
            print("XvResistor: Error: Incoming current", toCurrent, "exceeds resistor tolerance of \(_tolerance). Returning maximum range.")
            return _tolerance
        }
        
        return super.applyResistance(toCurrent: toCurrent)
    }
}
