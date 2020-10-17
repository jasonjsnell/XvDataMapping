
//  PeakDetection.swift
//  XvDataMapping
//
//  https://stackoverflow.com/questions/43583302/peak-detection-for-growing-time-series-using-swift/43607179#43607179
//  Created by Jean Paul
//  https://stackoverflow.com/users/2431885/jean-paul
//  Edited by Jason Snell on 10/16/20

import Foundation

public struct XvPeakDetectionPacket {
    
    init(peaks:[Double], averagedValues:[Double], standardDeviationValues:[Double]) {
        self.peaks = peaks
        self.averagedValues = averagedValues
        self.standardDeviationValues = standardDeviationValues
    }
    var peaks:[Double]
    var averagedValues:[Double]
    var standardDeviationValues:[Double]
}

public class XvPeakDetection {
    
    public init(
        threshold:Double,
        averagingLag:Int,
        lagDeviation:Int,
        averagingInfluence:Double,
        deviationInfluence:Double
    ){
        
        _threshold = threshold
        _averagingLag = averagingLag
        _lagDeviation = lagDeviation
        _averagingInfluence = averagingInfluence
        _deviationInfluence = deviationInfluence
    }
    
    // Smooth z-score thresholding filter
    public func process(y: [Double]) -> XvPeakDetectionPacket? {

        // Create arrays
        var peaks:[Double] = [Double](repeating: 0.0, count: y.count)
        var filteredYmean:[Double] = [Double](repeating: 0.0, count: y.count)
        var filteredYstd:[Double] = [Double](repeating: 0.0, count: y.count)
        var avgFilter:[Double] = [Double](repeating: 0.0, count: y.count)
        var stdFilter:[Double] = [Double](repeating: 0.0, count: y.count)

        // Initialise variables
        for i in 0..._averagingLag-1 {
            peaks[i] = 0
            filteredYmean[i] = y[i]
            filteredYstd[i] = y[i]
        }

        //confirm the lag times within the range of the signal array
        if (_averagingLag > y.count || _lagDeviation > y.count){
            print("XvPeakDetection: Lag time cannot be longer than the sample buffer size")
            return nil
        }
        
        // Start filter
        avgFilter[_averagingLag-1] = getMedian(array: subArray(array: y, s: 0, e: _averagingLag-1))
        stdFilter[_lagDeviation-1] = standardDeviation(array: subArray(array: y, s: 0, e: _lagDeviation-1))

        for i in max(_averagingLag, _lagDeviation)...y.count-1 {
            
            if abs(y[i] - avgFilter[i-1]) > threshold*stdFilter[i-1] {
                
                if y[i] > avgFilter[i-1] {
                    peaks[i] = 1      // Positive signal
                } else {
                    peaks[i] = -1       // Negative signal
                }
                
                filteredYmean[i] = _averagingInfluence * y[i] + (1 - _averagingInfluence) * filteredYmean[i-1]
                filteredYstd[i] = _deviationInfluence * y[i] + (1 - _deviationInfluence) * filteredYstd[i-1]
            } else {
                // No signal
                return nil
            }
            
            // Adjust the filters
            avgFilter[i] = getMedian(array: subArray(array: filteredYmean, s: i-_averagingLag, e: i))
            stdFilter[i] = standardDeviation(array: subArray(array: filteredYstd, s: i-_lagDeviation, e: i))
        }

        return XvPeakDetectionPacket(peaks: peaks, averagedValues: avgFilter, standardDeviationValues: stdFilter)
        
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
    fileprivate func standardDeviation(array:[Double]) -> Double {
        
        let length:Double = Double(array.count)
        let avg:Double = array.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff:Double = array.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    // Function to extract some range from an array
    fileprivate func subArray<T>(array: [T], s: Int, e: Int) -> [T] {
        if e > array.count {
            return []
        }
        return Array(array[s..<min(e, array.count)])
    }
    
    //MARK: Vars
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
    
    fileprivate var _lagDeviation:Int
    public var lagDeviation:Int {
        get { return _lagDeviation }
        set { _lagDeviation = newValue }
    }
    
    fileprivate var _averagingInfluence:Double
    public var averagingInfluence:Double {
        get { return _averagingInfluence }
        set { _averagingInfluence = newValue }
    }
    
    fileprivate var _deviationInfluence:Double
    public var deviationInfluence:Double {
        get { return _deviationInfluence }
        set { _deviationInfluence = newValue }
    }
    
}
