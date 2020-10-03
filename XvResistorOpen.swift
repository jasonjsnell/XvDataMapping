//
//  XvResistorOpen.swift
//  XvDataMapping
//
//  Created by Jason Snell on 10/1/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

/*
 
 This module slows down the rate of change of a changing variable, the way an electric resistor slows down a flow of electricity.
 
 The resistor can be set up with an increment and decrement. This can be used when the valu may not have a maximum amount, so the flow variables determine how fast the value can climb or descend.
 
 Can accept Double, CGFloat
 */

import Foundation

public class XvResistorOpen:Resistor {
    
    public override init(changeRate:Double) {
        super.init(changeRate: changeRate)
    }
    
    public override init(increment:Double, decrement:Double) {
        super.init(increment: increment, decrement: decrement)
    }
}
