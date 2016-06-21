//
//  NewRunViewController.swift
//  Runner
//
//  Created by liuwq on 16/6/2.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit
import AVFoundation

class NewRunViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    
    var started = false
    var upcomingBadge:Badge!
    @IBOutlet weak var nextBadgeLabel:UILabel!
    @IBOutlet weak var nextBadgeImageView:UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            self.mapView.delegate = self
            mapView.mapType = .Standard
            mapView.showsUserLocation = true
            //mapView.setRegion(animated: true)
            
        }
    }
    
    var managedObjectContext:NSManagedObjectContext?
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var distLabel: UILabel!
    var timer:NSTimer?
    var second = 0
    var distance:Float = 0
    var validDistance:Float = 0
    let locationManager = CLLocationManager()
    var locations = [CLLocation]()
    var run:Run?
    
    @IBAction func startBtnTapped(sender: UIButton) {
        
        
        //change the state
        started = true;
        
        //hidden the start UI
        self.startButton.hidden = true
        //self.startLocationUpdates()
        
        //show the running UI
        self.timeLabel.hidden = false
        self.distLabel.hidden = false
        self.paceLabel.hidden = false
        self.stopButton.hidden = false
        self.nextBadgeImageView.hidden = false
        self.nextBadgeLabel.hidden = false
        
        self.second = 0
        self.distance = 0
        self.validDistance = 0
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updatePerSecond), userInfo: nil, repeats: true)
        self.locations.removeAll()
        
        //self.locationManager.startUpdatingLocation()
        //print("start button tapped")
    }
    
    
    @IBAction func stopBtnTapped(sender: AnyObject) {
        
        //change the state
        started = false
        
        let alert = UIAlertController(title: "stop", message: "", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "撤销", style: .Default)
            {
            (action)
            in
                self.startButton.hidden = false
                self.stopButton.hidden = true
            }
        
        let saveAction = UIAlertAction(title: "保存", style:.Default) { (action) in
            self.saveRun()
            self.performSegueWithIdentifier("RunDetails", sender: nil)
        }
        
        let discardAction = UIAlertAction(title: "放弃", style: .Cancel) { (action) in
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addAction(discardAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    //mapkit delegate
    
    //rendererForOverlay
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if ((overlay as? MKPolyline) != nil){
            let aRenderer = MKPolylineRenderer(overlay: overlay)
            aRenderer.strokeColor = UIColor.blueColor()
            aRenderer.lineWidth = 3
            return aRenderer
        }
        
        
        return MKOverlayRenderer()
    }
    
    func startup()
    {
        self.timeLabel.text = ""
        self.timeLabel.hidden = true
        self.distLabel.hidden = true
        self.paceLabel.hidden = true
        self.stopButton.hidden = true
        self.nextBadgeLabel.hidden = true
        self.nextBadgeImageView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.startup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //start to update user's position
        self.startLocationUpdates()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePerSecond()
    {
        self.second += 1
        self.timeLabel.text = "用时: " + Math.stringifySecondCount(self.second)
        //self.distLabel.text = "跑了: " + Math.stringifyDistance(self.distance)
        self.distLabel.text = "跑了: " + Math.stringifyDistance(self.validDistance)
        //self.paceLabel.text = "配速: " + Math.stringifyAvgPaceFromDist(self.distance, overtime: self.second)
        self.paceLabel.text = "配速: " + Math.stringifyAvgPaceFromDist(self.validDistance, overtime: self.second)
        self.checkNextBadge();
        //self.nextBadgeLabel.text = "\(Math.stringifyDistance(self.upcomingBadge.distance - self.distance)) until \(self.upcomingBadge.name)!"
        self.nextBadgeLabel.text = "还有\(Math.stringifyDistance(self.upcomingBadge.distance - self.validDistance))到达\(self.upcomingBadge.name)"
        //print(self.timeLabel.frame.origin)
    }
    
    func checkNextBadge()
    {
        let controller = BadgeController()
        //let nextBadge = controller.nextBadgeForDistance(self.distance)
        let nextBadge = controller.nextBadgeForDistance(self.validDistance)
        if self.upcomingBadge != nil &&  nextBadge.name != self.upcomingBadge.name{
            self.playSuccessSound()
        }
        
        self.upcomingBadge = nextBadge
        self.nextBadgeImageView.image = UIImage(named: nextBadge.imageName)
    }
    
    func playSuccessSound()
    {
        
        //let path = NSBundle.mainBundle().pathForResource("success", ofType: "wav")
        //let url = NSURL(fileURLWithPath: path!, isDirectory: false)
        //let url = NSURL(fileURLWithPath: path!)
        let url = NSBundle.mainBundle().URLForResource("success", withExtension: "wav")
        do{
            let audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            //print("should play the sound")
        }catch{
            print("Error getting the audio file")
        }
//        var soundID = SystemSoundID()
//        AudioServicesCreateSystemSoundID(CFBridgingRetain(url) as! CFURLRef, &soundID)
//        
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func startLocationUpdates()
    {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = .Fitness
        self.locationManager.distanceFilter = 5
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    //When location updates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        for location in locations{
                let eventDate = location.timestamp
                let howRecent = eventDate.timeIntervalSinceNow
                if abs(howRecent) < 10.0 && location.horizontalAccuracy < 20{
                    //self.distance  += Float(location.distanceFromLocation(self.locations?.last ?? 0.0)
                    if self.locations.last != nil{
                        self.distance += Float(location.distanceFromLocation(self.locations.last!))
                        self.validDistance += Float(location.distanceFromLocation(self.locations.last!))
                    
                        var coords = Array(count: 2, repeatedValue: CLLocationCoordinate2D())
                        coords[0] = (self.locations.last?.coordinate)!
                        coords[1] = location.coordinate
                        
                        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0)
                        self.mapView.setRegion(region, animated: true)
                        if started{
                            self.mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                        }
                    
                    }
                    
                    self.locations.append(location)
                    
                }
        }
        
        //print("location updated")
    }
    
    func saveRun()
    {
        let newRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: self.managedObjectContext!) as! Run
        
        //newRun.distance = self.distance
        newRun.distance = self.validDistance
        newRun.duration = self.second
        newRun.timestamp = NSDate()
        
        //var locas = [Location]()
        for location in self.locations
        {
            let locationObject = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: self.managedObjectContext!) as! Location
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            //locas.append(locationObject)
            newRun.locations?.insert(locationObject)
        }
        //newRun.locations = NSSet(array: locas) as? Set<Location>
        //newRun.locations = locas as AnyObject as? NSMutableArray
        
        //save the context
        do {
            try self.managedObjectContext?.save()
        }catch{
            abort()
        }
        
        self.run = newRun
        timer?.invalidate()
        
        //print("run saved")
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       let dvc = segue.destinationViewController as! DetailViewController
        dvc.run = self.run
        //print("the number of points is \(dvc.run?.locations?.count)")
    }
    

}
