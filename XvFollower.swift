//
//  XvFollower.swift
//  XvDataMapping
//
//  Created by Jason Snell on 12/26/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation

//similar to XvResistor but it has a target that can be set, and the current value moves towards it as the object receives an update command (usually from a render cycle
public class XvFollower {
    
    fileprivate let _resistor:XvOpenResistor
    
    public var current:Double {
        get { return _currentValue }
    }
    fileprivate var _currentValue:Double
    
    public var target:Double {
        get { return _targetValue }
        set { _targetValue = newValue }
    }
    fileprivate var _targetValue:Double
    
    public init(increment:Double, decrement:Double, startingCurrent:Double = 0.0){
        
        _currentValue = startingCurrent
        _targetValue = startingCurrent
        _resistor = XvOpenResistor(increment: increment, decrement: decrement, startingCurrent: startingCurrent)
    }
    
    public init(changeRate:Double, startingCurrent:Double = 0.0){
        
        _currentValue = startingCurrent
        _targetValue = startingCurrent
        _resistor = XvOpenResistor(changeRate: changeRate, startingCurrent: startingCurrent)
    }
    
    public func update() -> Double {
        
        _currentValue = _resistor.applyResistance(toCurrent: _targetValue)
        return _currentValue
    }
    
}
