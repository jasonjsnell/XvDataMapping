//
//  XvResistor.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/6/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//


import Foundation
import UIKit


//MARK: Open Resistor
/*
 
 This module slows down the rate of change of a changing variable, the way an electric resistor slows down a flow of electricity.
 
 The resistor can be set up with an increment and decrement. This can be used when the valu may not have a maximum amount, so the flow variables determine how fast the value can climb or descend.
 
 Can accept Double, CGFloat
 */

public class XvOpenResistor:Resistor {
    
    public override init(changeRate:Double, startingCurrent:Double = 0.0) {
        super.init(changeRate: changeRate, startingCurrent: startingCurrent)
    }
    
    public override init(increment:Double, decrement:Double, startingCurrent:Double = 0.0) {
        super.init(increment: increment, decrement: decrement, startingCurrent: startingCurrent)
    }
}


//MARK: Closed Resistor
/*
 
 This module slows down the rate of change of a changing variable, the way an electric resistor slows down a flow of electricity.
 
 The resistor can be set up with a tolerance (maximum current amount) and resistance value, which the flow is calculated. These metaphors mirror the electric circuit the most and can be helpful when using this object.
 
 Can accept Double, CGFloat
 */

public class XvClosedResistor:Resistor {
    
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
    public override init(tolerance:Double, resistance:Double, startingCurrent:Double = 0.0) {
        
        self._tolerance = tolerance
        self._upwardsResistance = resistance
        self._downwardsResistance = resistance
        
        super.init(tolerance: tolerance, resistance: resistance, startingCurrent: startingCurrent)
    }
    
    //same as above but can specify unique resistance for upwards flow or downwards flow
    public override init(tolerance:Double, upwardsResistance:Double, downwardsResistance:Double, startingCurrent:Double = 0.0) {
        
        self._tolerance = tolerance
        self._upwardsResistance = upwardsResistance
        self._downwardsResistance = downwardsResistance
        
        super.init(tolerance: tolerance, upwardsResistance: upwardsResistance, downwardsResistance: downwardsResistance, startingCurrent: startingCurrent)
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


//MARK: Core class
public class Resistor {
    
    //how fast the current can increase
    
    public var increment:Double
    
    internal func setIncrement(tolerance:Double, resistance:Double) {
        
        //set new increment
        increment = tolerance-resistance
        
        //error check the new values
        errorCheck(tolerance: tolerance, resistance: resistance)
    }
    
    //how fast the current can decrease
    public var decrement:Double
    
    internal func setDecrement(tolerance:Double, resistance:Double) {
        
        //set new increment
        decrement = tolerance-resistance
        
        //error check the new values
        errorCheck(tolerance: tolerance, resistance: resistance)
    }
    
    //flow of the current
    public var current:Double {
        get {
            return _current
        }
    }
    fileprivate var _current:Double
   
    init(tolerance:Double, resistance:Double, startingCurrent:Double = 0.0) {
        
        //resistance is how much to block the current
        
        //flow = tolerance - resistance
        self.increment = tolerance - resistance
        self.decrement = tolerance - resistance
        self._current = startingCurrent
        
        errorCheck(tolerance: tolerance, resistance: resistance)
    }
    
    //same as above but can specify unique resistance for upwards flow or downwards flow
    init(tolerance:Double, upwardsResistance:Double, downwardsResistance:Double, startingCurrent:Double = 0.0) {
        
        self.increment = tolerance - upwardsResistance
        self.decrement = tolerance - downwardsResistance
        self._current = startingCurrent
        
        errorCheck(tolerance: tolerance, resistance: upwardsResistance)
        errorCheck(tolerance: tolerance, resistance: downwardsResistance)
    }
    
    public init(changeRate:Double, startingCurrent:Double = 0.0) {
        self.increment = changeRate
        self.decrement = changeRate
        self._current = startingCurrent
    }
    
    public init(increment:Double, decrement:Double, startingCurrent:Double = 0.0) {
        self.increment = increment
        self.decrement = decrement
        self._current = startingCurrent
    }
    
    public func applyResistance(toCurrent:Double) -> Double {
        
        //otherwise adjust the current up or down based on the up flow or down flow
        if (toCurrent > _current) {
            
            //increasing the current:
            
            // if near the top...
            if ((_current + increment) >= toCurrent) {
                
                //...snap to top
                _current = toCurrent
                
            } else {
                
                // else move up by the increment
                _current += increment
            }
        } else if (toCurrent < _current) {
            
            // decreasing the current:
            
            // if near the bottom...

            if ((_current - decrement) <= toCurrent){
                
                //... snap to bottom
                _current = toCurrent
                
            } else {
                
                //else move down by increment
                _current -= decrement
            }
        } else {
            
            //no change to report
            //return incoming current
            return toCurrent
        }
        
        //round to 6 decimals to avoid miniscule numbers and Number.Epsilon (2.7755575615628914e-17)
        _current = Double(Int(_current * 100000)) / 100000
        
        return _current
    }
    
    public func applyResistance(toCurrent:CGFloat) -> CGFloat {
        
        //route to double func
        return CGFloat(applyResistance(toCurrent: Double(toCurrent)))
    }

    //MARK: Error checking
    fileprivate func errorCheck(tolerance:Double, resistance:Double){
        
        if (resistance >= tolerance) {
            print("XvResistor: Warning: Object will not transform incoming values when resistance is more than tolerance")
            fatalError()
        }
        
        if (tolerance == 0.0) {
            print("XvResistor: Warning: Object will not transform incoming values when tolerance is set to 0.0")
            fatalError()
        }
        
    }
}

