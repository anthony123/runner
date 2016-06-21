//
//  HomeViewController.swift
//  Runner
//
//  Created by liuwq on 16/6/2.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var managedObjectContext:NSManagedObjectContext?
    var runArray:[Run]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Run", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            self.runArray =  try (self.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Run])
            //print("You have run \(self.runArray?.count) times")
        }catch {
            abort()
        }
        
    }
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "run"{
            //print("in the new run segue")
            let nrvc = segue.destinationViewController as! NewRunViewController
            nrvc.managedObjectContext = self.managedObjectContext
        }else if segue.identifier == "badge"{
            if let btvc = segue.destinationViewController as? BadgesTableViewController{
                let bc = BadgeController()
                btvc.earnStatusArray = bc.earnStatusForRuns(self.runArray!)
            }
        }else if segue.identifier == "show records"{
            if let rdtvc = segue.destinationViewController as? RecordDetailTableViewController{
                rdtvc.runs = self.runArray!
            }
            
        }
    }
}