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
    
    public init(with notes:[UInt8]) {
        
        self.notes = notes
        slotSize = 1.0 / Double(notes.count)
    }
    
    public func getNote(from percent:Double) -> UInt8? {
        
        //error check on incoming values
        if (percent > 1.0 || percent < 0.0) {
            print("XvwaveKeyboard: Error: Incoming percent needs to be in sbetween 0.0 and 1.0. Returning nil")
            return nil
        }
        
        //calc position based on percentage
        var notePosition:Int  = Int(percent / slotSize)
        
        //1.0 becomes top slot
        if (notePosition >= notes.count) {
            notePosition = notes.count-1
        }
        
        //grab note and add tune (which can be negative or positive)
        let note:UInt8 = notes[notePosition] + _tune
        
        //attenuate note to safe range
        if let attnNote:UInt8 = attn.attenuate(value: note) {
            
            return attnNote
            
        } else {
            return nil
        }
    }
}
