//
//  BadgeDetailsViewController.swift
//  Runner
//
//  Created by liuwq on 16/6/12.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit

class BadgeDetailsViewController: UIViewController
{
    var earnStatus:BadgeEarnStatus!
    @IBOutlet weak var badgeImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var earnedLabel:UILabel!
    @IBOutlet weak var silverLabel:UILabel!
    @IBOutlet weak var goldLabel:UILabel!
    @IBOutlet weak var bestLabel:UILabel!
    @IBOutlet weak var silverImageView:UIImageView!
    @IBOutlet weak var goldImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI/8))
        
        self.nameLabel.text = self.earnStatus.badge?.name
        self.distanceLabel.text = Math.stringifyDistance(self.earnStatus.badge!.distance)
        self.badgeImageView.image = UIImage(named: (self.earnStatus.badge?.imageName)!)
        //self.earnedLabel.text = "完成日期： \(formatter.stringFromDate(self.earnStatus.earnRun!.timestamp!))"
        self.earnedLabel.text = "完成时间： \(Math.stringifyDate(self.earnStatus.earnRun!.timestamp!))"
        
        if self.earnStatus.silverRun != nil{
            self.silverImageView.transform = transform
            self.silverImageView.hidden = false
            //self.silverLabel.text = "获得日期 \(formatter.stringFromDate(self.earnStatus.silverRun!.timestamp!))"
            self.silverLabel.text = "获取时间：\(Math.stringifyDate(self.earnStatus.silverRun!.timestamp!))"
        }else{
            self.silverImageView.hidden = true
            self.silverLabel.text = "步频大于\(Math.stringifyAvgPaceFromDist((self.earnStatus.earnRun!.distance?.floatValue)!*Constants.silverMultiplier, overtime: Int(self.earnStatus.earnRun!.duration!))) 获得银勋章!"
        }
        
        //for golden
        if (self.earnStatus.goldRun != nil){
            self.goldImageView.transform = transform
            self.goldImageView.hidden = false
            //self.goldLabel.text = "获得日期 \(formatter.stringFromDate(self.earnStatus.goldRun!.timestamp!))"
            self.goldLabel.text = "获取时间: \(Math.stringifyDate(self.earnStatus.goldRun!.timestamp!))"
        }else{
            self.goldImageView.hidden = true
            self.goldLabel.text = "步频大于 \(Math.stringifyAvgPaceFromDist(self.earnStatus.earnRun!.distance!.floatValue*Constants.goldMultiplier, overtime: Int(self.earnStatus.earnRun!.duration!))) 获得金勋章!"
        }
        
        //self.bestLabel.text = "最佳成绩: \(Math.stringifyAvgPaceFromDist(self.earnStatus.bestRun!.distance!.floatValue, overtime: Int(self.earnStatus.bestRun!.duration!))), \(formatter.stringFromDate(self.earnStatus.bestRun!.timestamp!))"
        self.bestLabel.text = "最佳成绩: \(Math.stringifyAvgPaceFromDist(self.earnStatus.bestRun!.distance!.floatValue, overtime: Int(self.earnStatus.bestRun!.duration!))), \(Math.stringifyDate(self.earnStatus.bestRun!.timestamp!))"
        
        
    }
    
    @IBAction func infoButtonPressed(sender:UIButton)
    {
        let alert = UIAlertController(title: self.earnStatus.badge!.name, message: self.earnStatus.badge!.information, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
