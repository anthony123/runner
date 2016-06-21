//
//  BadgeController.swift
//  Runner
//
//  Created by liuwq on 16/6/8.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import Foundation
import CoreLocation

class BadgeController{
    var badges = [Badge]()
    
    
    func bestBadgeForDistance(distance:Float)->Badge
    {
        var bestBadge = self.badges.first
        
        for badge in self.badges{
            if distance < badge.distance{
                break;
            }
            bestBadge = badge
        }
        
        return bestBadge!
    }
    
    func annotationsForRun(run:Run)->[BadgeAnnotation]
    {
        var annotations = [BadgeAnnotation]()
        var locaitonIndex = 1
        var distance:Float = 0.0
        
        for badge in self.badges{
            if badge.distance > run.distance?.floatValue{
                break;
            }
            
            var locations = [Location]()
            for location in run.locations!{
                locations.append(location)
            }
            
            locations.sortInPlace({ (location1, location2) -> Bool in
                location1.timestamp?.timeIntervalSinceReferenceDate < location2.timestamp?.timeIntervalSinceReferenceDate
            })
            
            while locaitonIndex < locations.count{
                let firstLoc = locations[locaitonIndex-1]
                let secondLoc = locations[locaitonIndex]
                
                let firstLocCL = CLLocation(latitude: Double(firstLoc.latitude!), longitude: Double(firstLoc.longitude!))
                let secondLocCL = CLLocation(latitude: Double(secondLoc.latitude!), longitude: Double(secondLoc.longitude!))
                
                distance += Float(secondLocCL.distanceFromLocation(firstLocCL))
                locaitonIndex += 1
                
                if distance >= badge.distance{
                    let annotation = BadgeAnnotation()
                    annotation.coordinate = secondLocCL.coordinate
                    annotation.subtitle = Math.stringifyDistance(badge.distance)
                    annotation.imageName = badge.imageName
                    annotations.append(annotation)
                    break;
                }
            }
        }
        
        return annotations
    }
    
    func nextBadgeForDistance(distance:Float)->Badge
    {
        var nextBadge = badges.first
        for badge in self.badges{
            nextBadge = badge
            if distance < badge.distance{
                break;
            }
        }
        
        return  nextBadge!
        
    }
   
    func earnStatusForRuns(runs:[Run])->[BadgeEarnStatus]
    {
        var earnStatuses = [BadgeEarnStatus]()
        for badge in self.badges{
            var earnStatus = BadgeEarnStatus()
            earnStatus.badge = badge
            
            for run in runs{
                if run.distance?.floatValue > badge.distance{
                    if (earnStatus.earnRun == nil){
                        earnStatus.earnRun = run
                    }
                    let earnRunSpeed = (earnStatus.earnRun?.distance?.floatValue)! / (earnStatus.earnRun?.duration?.floatValue)!
                    let runSpeed = (run.distance?.floatValue)! / (run.duration?.floatValue)!
                    
                    if earnStatus.silverRun == nil && runSpeed > earnRunSpeed*Constants.silverMultiplier{
                        earnStatus.silverRun = run
                    }
                    
                    if earnStatus.goldRun == nil && runSpeed > earnRunSpeed*Constants.goldMultiplier{
                        earnStatus.goldRun = run
                    }
                    
                    if earnStatus.bestRun == nil {
                        earnStatus.bestRun = run
                    }else{
                        let bestRunSpeed = (earnStatus.bestRun?.distance?.floatValue)! / (earnStatus.bestRun?.duration?.floatValue)!
                        if runSpeed > bestRunSpeed{
                            earnStatus.bestRun = run
                        }
                    }
                }
            }
            
            earnStatuses.append(earnStatus)
        }
        
        print("you have earned \(earnStatuses.count) badges")
        
        return earnStatuses
    }
    
    private func addBadge(badgeDic:Dictionary<String, String>)
    {
        let name = badgeDic["name"]
        let info = badgeDic["information"]
        let imageName = badgeDic["imageName"]
        let distance = Float(badgeDic["distance"]!)
        
        let badge = Badge(name: name!, information:info!, imageName: imageName!, distance:distance!)
        
        self.badges.append(badge)
    }
    
    init()
    {
        let filePath = NSBundle.mainBundle().pathForResource("badges", ofType: "txt")
        var content:String
        do{
            try content = String(contentsOfFile: filePath!)
        }catch{
            abort()
        }
        
        let data = content.dataUsingEncoding(NSUTF8StringEncoding)
        var badgeDic = [Dictionary<String, String>]()
        do{
            badgeDic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [Dictionary<String, String>]
        }catch{
            abort()
        }
        
        for badge in badgeDic{
            addBadge(badge)
        }
    }
}
