//
//  Math.swift
//  Runner
//
//  Created by liuwq on 16/6/2.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Math{
    static let metersInKM:Float = 1000
    
    
    
    static func stringifyDigit(digit:Int)->String
    {
        return (digit >= 10) ? "\(digit)":"0\(digit)"
    }
    
    
    static func colorSegmentsForLocations(locations:[Location])->[MulticolorPolylineSegment]
    {
        var speeds = [Double]()
        var slowestSpeed = DBL_MAX
        var fastestSpeed = 0.0
        
        //rgb for red(slowest)
        let r_red = 1.0
        let r_green = 20/255.0
        let r_blue = 44/255.0
        
        //rgb for yellow(middle)
        let y_red = 1.0
        let y_green = 215/255.0
        let y_blue = 0.0
        
        //rgb for blue(fastest)
        let g_red = 0.0
        let g_green = 146/255.0
        let g_blue = 78/255.0

        var segments = [MulticolorPolylineSegment]()
        
        for i in 1..<locations.count{
            let firstLoc = locations[i-1]
            let secondLoc = locations[i]
            let firstCL = CLLocation(latitude: Double(firstLoc.latitude!), longitude: Double(firstLoc.longitude!))
            let secondCL = CLLocation(latitude: Double(secondLoc.latitude!), longitude: Double(secondLoc.longitude!))
            let dist = secondCL.distanceFromLocation(firstCL)
            let duration = secondLoc.timestamp?.timeIntervalSinceDate(firstLoc.timestamp!)
            let speed = dist/duration!
            slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed
            fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed
            speeds.append(speed)
            
        }
        
        let meanSpeed = (slowestSpeed + fastestSpeed)/2;
        
        var color = UIColor()
        for (index, speed) in speeds.enumerate(){
            if speed < meanSpeed{
                let ratio = (speed - slowestSpeed) / (meanSpeed - slowestSpeed)
                let red = r_red + ratio*(y_red-r_red)
                let green = r_green + ratio*(y_green - r_green)
                let blue = r_blue + ratio*(y_blue - r_blue)
                color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
            }else{
                let ratio = (speed-meanSpeed)/(fastestSpeed-meanSpeed)
                let red = y_red + ratio*(g_red - y_red)
                let green = y_green + ratio*(g_green - y_green)
                let blue = y_blue + ratio*(g_blue - y_blue)
                color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
            }
            
            var coords = [CLLocationCoordinate2D]()
            let firstcoord = CLLocationCoordinate2D(latitude: Double(locations[index].latitude!), longitude: Double(locations[index].longitude!))
            let secondcoord = CLLocationCoordinate2D(latitude: Double(locations[index+1].latitude!), longitude: Double(locations[index+1].longitude!))
            coords.append(firstcoord)
            coords.append(secondcoord)
            let segment = MulticolorPolylineSegment(coordinates: &coords, count: 2)
            segment.color = color
            segments.append(segment)

        }
        
        
        
        return segments
    }
    
    static func stringifyDate(date:NSDate)->String
    {
        let canlender = NSCalendar.currentCalendar()
        let year = canlender.component(.Year, fromDate: date)
        let month = canlender.component(.Month, fromDate: date)
        let monthString = month >= 10 ? (String(month)):("0" + String(month))
        let day = canlender.component(.Day, fromDate: date)
        let dayString = day >= 10 ? (String(day)):("0" + String(day))
        let hour = canlender.component(.Hour, fromDate: date)
        let hourString = hour>=10 ? (String(hour)) : ("0" + String(hour))
        let minute = canlender.component(.Minute, fromDate: date)
        let minuteString = minute>=10 ? (String(minute)):("0" + String(minute))
        
        let dateString = String(year) + "-" + monthString + "-" + dayString + " " + hourString + ":" + minuteString
        return dateString
    }
    
    static func stringifyAvgPaceFromDist(dist:Float, overtime:Int)->String
    {
        if overtime == 0{
            return "0"
        }
        
        let avgSecondPerkm = (dist == 0) ? 0 :Int(Float(overtime)/(dist/1000))
//        print(avgSecondPerkm)
//        print("dist = \(dist)")
//        print("overtime = \(overtime)")
        let minutes = avgSecondPerkm/60
        let seconds = avgSecondPerkm%60;
        
        let minusteString = stringifyDigit(minutes)
        let secondString = stringifyDigit(seconds)
        
        return minusteString + "′" + secondString+"″"
        
    }
    
    static func stringifySecondCount(seconds:Int)->String{
        var remainingSeconds = seconds
        let hours = remainingSeconds/3600
        remainingSeconds = remainingSeconds - hours*3600
        let minutes = remainingSeconds/60
        remainingSeconds = remainingSeconds - minutes*60
        
        let hourString = stringifyDigit(hours)
        let minuteString = stringifyDigit(minutes)
        let secondString = stringifyDigit(remainingSeconds)
        
        return hourString + ":" + minuteString + ":" + secondString
        
    }
    
    static func stringifyDistance(meters:Float)->String
    {
        let unitName:String = "km"
        let unitDivider:Float = Math.metersInKM
        
        return String(format: "%.2f", (meters/unitDivider)) + " \(unitName)"
    }

}
