//
//  RecordDetailTableViewController.swift
//  Runner
//
//  Created by liuwq on 16/6/17.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit

class RecordDetailTableViewController: UITableViewController
{
    var runs = [Run]()
    let dateFormatter = NSDateFormatter()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.runs.count
    }
    
    override func viewDidLoad() {
        dateFormatter.dateStyle = .MediumStyle
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("recordCell") as! RunRecordCell
        let currentRun = runs[index]
        let dateString = Math.stringifyDate(currentRun.timestamp!)
        
        //cell.RunDate.text = self.dateFormatter.stringFromDate(currentRun.timestamp!)
        cell.RunDate.text = dateString
        cell.RunDistance.text = Math.stringifyDistance((currentRun.distance?.floatValue)!)
        cell.RunDuration.text = Math.stringifySecondCount(Int(currentRun.duration!))

        return cell
    }
    
    
    
}
