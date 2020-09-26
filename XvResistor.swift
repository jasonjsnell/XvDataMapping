//
//  XvResistor.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/6/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//
/*
 
 This module slows down the rate of change of a changing variable.
 Init with a increment, and that is the amount an incoming variable can change in one step
 Can accept Double, CGFloat
 */

import Foundation
import UIKit

public class XvResistor {
    
    fileprivate var _attackSpeed:Double
    public var attackSpeed:Double {
        get { return _attackSpeed }
        set { _attackSpeed = newValue }
    }
    
    fileprivate var _releaseSpeed:Double
    public var releaseSpeed:Double {
        get { return _releaseSpeed }
        set { _releaseSpeed = newValue }
    }
    
    fileprivate var current:Double = 0.0 //current flow of data
    
    public init(resistance:Double) {
        
        self._attackSpeed = resistance
        self._releaseSpeed = resistance
        zeroCheck()
    }
    
    public init(attackSpeed:Double, releaseSpeed:Double) {
        
        self._attackSpeed = attackSpeed
        self._releaseSpeed = releaseSpeed
        zeroCheck()
    }
    
    public func resist(value:Double) -> Double? {
        
        if (value > current) {
            
            //increasing the value:
            
            // if near the top...
            if ((current + _attackSpeed) >= value) {
                
                //...snap to top
                current = value
                
            } else {
                
                // else move up by the increment
                current += _attackSpeed
            }
        } else if (value < current) {
            
            // decreasing values:
            
            // if near the bottom...

            if ((current - _releaseSpeed) <= value){
                
                //... snap to bottom
                current = value
                
            } else {
                
                //else move down by increment
                current -= _releaseSpeed
            }
        } else {
            
            //no change to report
            return nil
        }
        
        //round to 6 decimals to avoid miniscule numbers and Number.Epsilon (2.7755575615628914e-17)
        current = Double(Int(current * 100000)) / 100000
        
        return current
    }
    
    public func resist(value:CGFloat) -> CGFloat? {
        
        //route to double func
        if let newCurrent:Double = resist(value: Double(value)){
            return CGFloat(newCurrent)
        } else {
            //no change
            return nil
        }
    }

    //MARK: Error checking
    fileprivate func zeroCheck(){
        if (_attackSpeed == 0.0 || _releaseSpeed == 0.0){
            print("XvResistor: Warning: Object will not transform incoming values when increments are set to 0.0")
        }
    }
   
}
