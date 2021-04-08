//
//  XvWaveKeyboard.swift
//  XvDataMapping
//
//  Created by Jason Snell on 8/11/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

//deltaKeyboard = XvWaveKeyboard(notes:[36, 40, 43, 48, 52, 55, 60])
//let note:UInt8 = deltaKeyboard.getNote(from: delta.relative)

import Foundation

public class XvWaveKeyboard {
    
    //change tune for whole set of keyboard notes
    fileprivate var _tune:UInt8 = 0
    public var tune:UInt8 {
        get { return _tune }
        set { _tune = newValue }
    }
    
    public var notes:[UInt8] {
        get { return _notes }
    }
    fileprivate var _notes:[UInt8]
    fileprivate var slotSize:Double
    
    fileprivate let attn:XvAttenuator = XvAttenuator(min: 0, max: 127)
    
    public init(notes:[UInt8]) {
        
        self._notes = notes
        
        //the number of slots in the 0-1 spectrum is determined by how many notes are in the incoming array
        //so the slot size is 1.0 / number of slots
        
        slotSize = 1.0 / Double(_notes.count)
    }
    
    public func getNote(from percent:Double) -> UInt8 {
        
        var notePosition:Int = 0
        
        //error check on incoming values
        if (
            percent < 0 ||
            percent.isNaN ||
            percent.isInfinite ||
            percent > 1.0
        ) {
            //print("XvwaveKeyboard: Error: Incoming percent needs to be inbetween 0.0 and 1.0. Returning value from note position 0")
            
        } else {
            
            //calc position based on percent
            notePosition  = Int(percent / slotSize)
        }
        
        //keep within array
        if (notePosition < 0){
            notePosition = 0
        } else if (notePosition >= _notes.count){
            notePosition = _notes.count-1
        }
        
        //grab note and add tune (which can be negative or positive)
        let note:UInt8 = _notes[notePosition] + _tune
        
        //print("note", note, "pos", notePosition)
        //attenuate note to safe range
        return attn.attenuate(value: note)
    }
}
