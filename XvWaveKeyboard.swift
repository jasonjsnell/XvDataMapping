//
//  XvWaveKeyboard.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/11/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import Foundation

public class XvWaveKeyboard {
    
    //change tune for whole set of keyboard notes
    fileprivate var _tune:UInt8 = 0
    public var tune:UInt8 {
        get { return _tune }
        set { _tune = newValue }
    }
    
    fileprivate var notes:[UInt8]
    fileprivate var slotSize:Double
    
    fileprivate let attn:XvAttenuator = XvAttenuator(min: 0, max: 127)
    
    public init(notes:[UInt8]) {
        
        self.notes = notes
        
        //the number of slots in the 0-1 spectrum is determined by how many notes are in the incoming array
        //so the slot size is 1.0 / number of slots
        
        slotSize = 1.0 / Double(notes.count)
    }
    
    public func getNote(from percent:Double) -> UInt8? {
        
        //error check on incoming values
        if (
            percent < 0 ||
            percent.isNaN ||
            percent.isInfinite ||
            percent > 1.0
        ) {
            print("XvwaveKeyboard: Error: Incoming percent needs to be inbetween 0.0 and 1.0. Returning nil")
            return nil
        }
        
        //calc position based on percent
        var notePosition:Int  = Int(percent / slotSize)
        
        
        //keep within array
        if (notePosition < 0){
            notePosition = 0
        } else if (notePosition >= notes.count){
            notePosition = notes.count-1
        }
        
        //grab note and add tune (which can be negative or positive)
        let note:UInt8 = notes[notePosition] + _tune
        
        //attenuate note to safe range
        return attn.attenuate(value: note)
    }
}
