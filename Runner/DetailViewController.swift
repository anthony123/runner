//
//  DetailViewController.swift
//  Runner
//
//  Created by liuwq on 16/6/2.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var badgeImageView:UIImageView!
    @IBOutlet weak var infoButton:UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.mapType = .Standard
            mapView.delegate = self
        }
    }
    var locations = [Location]()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    @IBOutlet weak var paceLabel: UILabel!
    var run :Run?{
        didSet{
            //self.configureView()
            for location in (self.run?.locations)!{
                locations.append(location)
            }
            self.locations.sortInPlace { (location1, location2) -> Bool in
                location1.timestamp!.timeIntervalSinceNow < location2.timestamp!.timeIntervalSinceNow
            }
        }
    }
    

    func configureView()
    {
        self.distLabel.text = Math.stringifyDistance(Float(self.run?.distance ?? 0.0))
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        let dateString = Math.stringifyDate(self.run!.timestamp!)
        //self.dateLabel.text = formatter.stringFromDate(self.run!.timestamp!)
        self.dateLabel.text = dateString
        self.timeLabel.text = "用时: " + Math.stringifySecondCount(Int(self.run!.duration!))
        self.paceLabel.text = "配速: " + Math.stringifyAvgPaceFromDist(Float(self.run!.distance!), overtime: Int(self.run!.duration!))
        self.loadMap()
        
        let controller = BadgeController()
        let badge = controller.bestBadgeForDistance(self.run!.distance!.floatValue)
        self.badgeImageView.image = UIImage(named: badge.imageName)
        
    }
    
    @IBAction func infoButtonPressed()
    {
        let controller = BadgeController()
        let badge = controller.bestBadgeForDistance(self.run!.distance!.floatValue)
        let alert = UIAlertController(title: badge.name, message: badge.information, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func displayModeToggled(sender:UISwitch){
        self.badgeImageView.hidden = !sender.on
        self.infoButton.hidden = !sender.on
        self.mapView.hidden = sender.on
    }
    
    
    func mapRegion()->MKCoordinateRegion
    {
        var region:MKCoordinateRegion = MKCoordinateRegion()
        let initLoc = self.locations.first
        var minLat = Float(initLoc!.latitude!)
        var minLng = Float(initLoc!.longitude!)
        var maxLat = minLat
        var maxLng = minLng
        
        for location in self.locations {
            //print("latitude = \(location.latitude!)")
            //print("longtitude = \(location.longitude!)")
            if Float(location.latitude!) < minLat{
                minLat = Float(location.latitude!)
            }
            
            if Float(location.latitude!) > maxLat{
                maxLat = Float(location.latitude!)
            }
            
            if Float(location.longitude!) < minLng{
                minLng = Float(location.longitude!)
            }
            
            if Float(location.longitude!) > maxLng{
                maxLng = Float(location.longitude!)
            }
        }
        //print("maxLat = \(maxLat), minLat = \(minLat), maxLng = \(maxLng), minLng = \(minLng)")
        region.center.latitude = Double((minLat + maxLat)/2)
        region.center.longitude = Double((minLng + maxLng)/2)
        region.span.latitudeDelta = Double((maxLat - minLat))*2
        region.span.longitudeDelta = Double((maxLng - minLng))*2
        //print("in the mapRegion")
        //print(region.center)
        //print(region.span)
        return region

        
    }
    
    
    func loadMap()
    {
        if self.locations.count > 0{
            self.mapView.hidden = false
            self.mapView.setRegion(self.mapRegion(), animated: true)
            //self.mapView.addOverlay(self.polyLine())
            var locs = [Location]()
            for location in (self.locations){
                locs.append(location)
            }
            let segments = Math.colorSegmentsForLocations(locs)
            self.mapView.addOverlays(segments)
            let controller = BadgeController()
            self.mapView.addAnnotations(controller.annotationsForRun(self.run!))
            //print("map loaded")
            //print(self.mapView.region)
            
        }
    }
    
    func polyLine()->MKPolyline
    {
        var coords: [CLLocationCoordinate2D] = Array(count: (self.locations.count), repeatedValue: CLLocationCoordinate2D())
        
        for (index,location) in (self.locations.enumerate()){
            coords[index].latitude = Double(location.latitude!)
            coords[index].longitude = Double(location.longitude!)
        }
        
        return MKPolyline(coordinates: &coords, count: self.locations.count ?? 0)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let badgeAnnotation = annotation as! BadgeAnnotation
        var annView = mapView.dequeueReusableAnnotationViewWithIdentifier("checkpoint")
        if annView == nil{
            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "checkpoint")
            annView?.image = UIImage(named: "mapPin")
            annView?.canShowCallout = true

        }
        
        let badgeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 50))
        badgeImageView.image = UIImage(named: badgeAnnotation.imageName)
        badgeImageView.contentMode = .ScaleAspectFit
        annView?.leftCalloutAccessoryView = badgeImageView
        
        return annView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if ((overlay as? MulticolorPolylineSegment) != nil){
            let polyLine = overlay as! MulticolorPolylineSegment
            let aRender = MKPolylineRenderer(polyline: polyLine)
            //aRender.strokeColor = UIColor.blueColor()
            aRender.strokeColor = polyLine.color
            aRender.lineWidth = 3
            
            return aRender
        }
        
        return MKPolylineRenderer()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        //self.mapView.hidden = true
        self.badgeImageView.hidden = true
        self.infoButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

