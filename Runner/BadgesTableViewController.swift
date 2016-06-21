//
//  BadgesTableViewController.swift
//  Runner
//
//  Created by liuwq on 16/6/11.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit

class BadgesTableViewController: UITableViewController {
 var earnStatusArray = [BadgeEarnStatus]()
    let redColor = UIColor(red: 1.0, green: 20/255.0, blue: 44/255/0, alpha: 1.0)
    let greenColor = UIColor(red: 0.0, green: 146/255.0, blue: 78/255/0, alpha: 1.0)
    let dateFormatter = NSDateFormatter()
    var transform = CGAffineTransformMakeRotation(CGFloat(M_PI/8))
    
    
    override func viewDidLoad() {
        dateFormatter.dateStyle = .MediumStyle
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BadgeCell", forIndexPath: indexPath) as! BadgeCell
        let earnStatus = self.earnStatusArray[indexPath.row]
        
        cell.silverImageView.hidden = (earnStatus.silverRun != nil)
        cell.goldImageView.hidden = (earnStatus.goldRun != nil)
        
        if (earnStatus.earnRun != nil){
           cell.namedLabel.textColor = self.greenColor
            cell.namedLabel.text = earnStatus.badge?.name
            cell.descLabel.textColor = self.greenColor
            //cell.descLabel.text = "Earned: \(self.dateFormatter.stringFromDate((earnStatus.earnRun?.timestamp)!))"
            cell.descLabel.text = "获得时间：\(Math.stringifyDate(earnStatus.earnRun!.timestamp!))"
            cell.badgeImageView.image = UIImage(named: (earnStatus.badge?.imageName)!)
            cell.silverImageView.transform = self.transform
            cell.goldImageView.transform = self.transform
            cell.userInteractionEnabled = true
        }else{
            cell.namedLabel.textColor = self.redColor
            cell.namedLabel.text = "????"
            cell.descLabel.textColor = self.redColor
            cell.descLabel.text = "Run \(Math.stringifyDistance((earnStatus.badge?.distance)!))"
            cell.badgeImageView.image = UIImage(named: "question_badge.png")
            cell.userInteractionEnabled = false
        }
        
        return cell

        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earnStatusArray.count
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail"{
            if let bdvc = segue.destinationViewController as? BadgeDetailsViewController{
                let indexPath = self.tableView.indexPathForSelectedRow
                let earnStatus = self.earnStatusArray[indexPath!.row]
                bdvc.earnStatus = earnStatus
            }
    
        }
    }

}
