
//  PeakDetection.swift
//  XvDataMapping
//
//  https://stackoverflow.com/questions/43583302/peak-detection-for-growing-time-series-using-swift/43607179#43607179
//  Created by Jean Paul
//  https://stackoverflow.com/users/2431885/jean-paul
//  Edited by Jason Snell on 10/16/20

import Foundation

public struct XvPeakDetectionPacket {
    
    init(peaks:[Int], averagedValues:[Double], deviationValues:[Double]) {
        self.peaks = peaks
        self.averagedValues = averagedValues
        self.deviationValues = deviationValues
    }
    public var peaks:[Int]
    public var averagedValues:[Double]
    public var deviationValues:[Double]
}

public class XvPeakDetection {
    
    public init(
        bins:Int,
        threshold:Double,
        averagingLag:Int,
        deviationLag:Int,
        averagingInfluence:Double,
        deviationInfluence:Double
    ){
        
        //capture vars
        _bins = bins
        _threshold = threshold
        _averagingLag = averagingLag
        _deviationLag = deviationLag
        _averagingInfluence = averagingInfluence
        _deviationInfluence = deviationInfluence
        
        //init empty signal
        _signal = []
        
        //error checking
        if (_averagingLag > _bins || _deviationLag > _bins) {
            print("XvPeakDetection: Error: Lags (", _averagingLag, _deviationLag, ") can't be more than the bin length", _bins)
            fatalError()
        }
    }
    
    fileprivate let _bins:Int
    fileprivate var _signal:[Double]
    
    //MARK: - Process value
    //process one value at a time
    public func process(value:Double) -> XvPeakDetectionPacket? {
        
        //add value to end of the signal
        _signal.append(value)
        
        //buffer signal
        if (_bufferSignal()){
            
            //then detect peaks
            return _peakDetection()
        }
        
        return nil
    }
    
    //MARK: Process packet
    //this is a small array of several values, often used in device communication
    public func process(packet:[Double]) -> XvPeakDetectionPacket? {
        
        //append entire packet
        _signal += packet
        
        //buffer signal
        if (_bufferSignal()){
            
            //then detect peaks
            return _peakDetection()
        }
        
        return nil
    }
    
    //MARK: Process signal
    //this is an array the same length as the bins
    public func process(stream:[Double]) -> XvPeakDetectionPacket? {
        
        //if incoming signal is the size of bins
        if (stream.count == _bins) {
            
            //save and process
            _signal = stream
            return _peakDetection()
        
        } else {
            print("XvPeakDetection: Error: process: signal length", stream.count, "is not the same as bin length", _bins)
            return nil
        }
    }
    
    
    //MARK: - Peak detection -
    fileprivate func _peakDetection() -> XvPeakDetectionPacket?{

        /*
        //MARK: Error checking
        //confirm the lag times within the range of the signal array
        if (_averagingLag > _signal.count || _deviationLag > _signal.count){
            print("XvPeakDetection: Lag time cannot be longer than the sample buffer size", _signal.count)
            return nil
        }
        
        // Create arrays
        var peaks:[Int]            = [Int](repeating: 0, count: _signal.count)
        var filteredYAvg:[Double]  = [Double](repeating: 0.0, count: _signal.count)
        var filteredYDev:[Double]  = [Double](repeating: 0.0, count: _signal.count)
        var avgFilter:[Double]     = [Double](repeating: 0.0, count: _signal.count)
        var devFilter:[Double]     = [Double](repeating: 0.0, count: _signal.count)

        // Initialise variables
        for i in 0..._averagingLag-1 {
            peaks[i] = 0 // TODO: why is this set to zero again?
            filteredYAvg[i] = _signal[i]
            filteredYDev[i] = _signal[i] //TODO: why is deviation filter the length of the average filter?
        }
    
        // Start filter
        avgFilter[_averagingLag-1] = getMean(array: subArray(array: peaks, s: 0, e: _averagingLag-1))
        devFilter[_deviationLag-1] = getStandardDeviation(array: subArray(array: peaks, s: 0, e: _deviationLag-1))

        for i in max(_averagingLag, _deviationLag)...peaks.count-1 {
            
            if abs(peaks[i] - avgFilter[i-1]) > _threshold * devFilter[i-1] {
                
                if peaks[i] > avgFilter[i-1] {
                    peaks[i] = 1  // Positive signal
                } else {
                    peaks[i] = -1 // Negative signal
                }
                
                filteredYAvg[i] = _averagingInfluence * peaks[i] + (1 - _averagingInfluence) * filteredYAvg[i-1]
                filteredYDev[i] = _deviationInfluence * peaks[i] + (1 - _deviationInfluence) * filteredYDev[i-1]
                
            } else {
                // Not a peak
                peaks[i] = 0
                filteredYAvg[i] = _signal[i]
                filteredYDev[i] = _signal[i]
                
            }
            
            // Adjust the filters
            avgFilter[i] = getMean(array: subArray(array: filteredYAvg, s: i-_averagingLag, e: i))
            devFilter[i] = getStandardDeviation(array: subArray(array: filteredYDev, s: i-_deviationLag, e: i))
        }

        return XvPeakDetectionPacket(peaks: peaks, averagedValues: avgFilter, deviationValues: devFilter)
        */
        return nil
    }
    
    public func ThresholdingAlgo(y: [Double]) -> XvPeakDetectionPacket? {

        //MARK: Error checking
        //confirm the lag times within the range of the signal array
        if (_averagingLag > y.count || _deviationLag > y.count){
            print("XvPeakDetection: Lag time cannot be longer than the sample buffer size", y.count)
            return nil
        }
        
        // Create arrays
        var peaks   = Array(repeating: 0, count: y.count)
        var filteredYmean = Array(repeating: 0.0, count: y.count)
        var filteredYstd = Array(repeating: 0.0, count: y.count)
        var avgFilter = Array(repeating: 0.0, count: y.count)
        var devFilter = Array(repeating: 0.0, count: y.count)

        // Initialise variables
        for i in 0..._averagingLag-1 {
            peaks[i] = 0
            filteredYmean[i] = y[i]
            filteredYstd[i] = y[i]
        }

        // Start filter
        avgFilter[_averagingLag-1] = getMean(array: subArray(array: y, s: 0, e: _averagingLag-1))
        devFilter[_deviationLag-1] = getStandardDeviation(array: subArray(array: y, s: 0, e: _deviationLag-1))

        for i in max(_averagingLag,_deviationLag)...y.count-1 {
            if abs(y[i] - avgFilter[i-1]) > _threshold * devFilter[i-1] {
                if y[i] > avgFilter[i-1] {
                    peaks[i] = 1      // Positive signal
                } else {
                    peaks[i] = -1       // Negative signal
                }
                filteredYmean[i] = _averagingInfluence*y[i] + (1-_averagingInfluence)*filteredYmean[i-1]
                filteredYstd[i] = _deviationInfluence*y[i] + (1-_deviationInfluence)*filteredYstd[i-1]
            } else {
                peaks[i] = 0          // No signal
                filteredYmean[i] = y[i]
                filteredYstd[i] = y[i]
            }
            // Adjust the filters
            avgFilter[i] = getMean(array: subArray(array: filteredYmean, s: i-_averagingLag, e: i))
            devFilter[i] = getStandardDeviation(array: subArray(array: filteredYstd, s: i-_deviationLag, e: i))
        }

        return XvPeakDetectionPacket(peaks: peaks, averagedValues: avgFilter, deviationValues: devFilter)

    }
    
    //MARK: - Helpers -
    // Function to calculate the arithmetic mean
    fileprivate func getMean(array:[Double]) -> Double {
        
        let total:Double = array.reduce(0, +)
        return total / Double(array.count)
    }
    
    fileprivate func getMedian(array: [Double]) -> Double {
        
        let sorted:[Double] = array.sorted()
        if (sorted.count % 2 != 0) {
            return Double(sorted[sorted.count / 2])
        } else {
            return Double(sorted[sorted.count / 2] + sorted[sorted.count / 2 - 1]) / 2.0
        }
    }
    
    // Function to calculate the standard deviation
    fileprivate func getStandardDeviation(array:[Double]) -> Double {
        
        let length:Double = Double(array.count)
        let avg:Double = array.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff:Double = array.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    fileprivate func getMeanAbsoluteDeviation(array:[Double]) -> Double {
        
        //get mean of the array
        let mean:Double = getMean(array: array)
        
        //calculate distance between each number in area from the mean
        //but make all values positive (absolute value)
        let absoluteDeviations:[Double] = array.map { abs($0-mean) }
        
        //get the average (mean) absolute deviation
        return absoluteDeviations.reduce(0, +) / Double(absoluteDeviations.count)
    }
    
    // Function to extract some range from an array
    fileprivate func subArray<T>(array: [T], s: Int, e: Int) -> [T] {
        if e > array.count {
            return []
        }
        return Array(array[s..<min(e, array.count)])
    }
    
    fileprivate func _bufferSignal() -> Bool{
        
        if (_signal.count < _bins) {
            print("XvPeakDetection: Building buffer", _signal.count, "/", _bins)
            return false
        }
        
        //if signal goes above bin length
        if (_signal.count > _bins) {
            
            //remove the excess from the beginning of the array
            _signal.removeFirst(_signal.count-_bins)
        }
        return true
    }
    
    //MARK: - Acccessors -
    fileprivate let influenceAttn:XvAttenuator = XvAttenuator(min: 0.0, max: 1.0)
    fileprivate var _threshold:Double
    public var threshold:Double {
        get { return _threshold }
        set { _threshold = newValue }
    }
    
    fileprivate var _averagingLag:Int
    public var averagingLag:Int {
        get { return _averagingLag }
        set { _averagingLag = newValue }
    }
    
    fileprivate var _deviationLag:Int
    public var deviationLag:Int {
        get { return _deviationLag }
        set { _deviationLag = newValue }
    }
    
    fileprivate var _averagingInfluence:Double
    public var averagingInfluence:Double {
        get { return _averagingInfluence }
        set { _averagingInfluence = influenceAttn.attenuate(value: newValue) }
    }
    
    fileprivate var _deviationInfluence:Double
    public var deviationInfluence:Double {
        get { return _deviationInfluence }
        set { _deviationInfluence = influenceAttn.attenuate(value: newValue) }
    }
    
}
