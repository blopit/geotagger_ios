//
//  ViewController.swift
//  geotagger_ios
//
//  Created by Shrenil Patel on 2016-10-01.
//  Copyright © 2016 ___SHRENILPATEL___. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 300
    var locationManager: CLLocationManager!
    var myLocation:CLLocationCoordinate2D?
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let c = MKCircleRenderer(overlay: overlay)
            c.strokeColor = UIColor.redColor()
            c.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            c.lineWidth = 1
            return c
        } else {
            return MKPolylineRenderer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenterCoordinate(coor, animated: true)
        }
        addLongPressGesture()
        
        let artwork = Tag(title: "King David Kalakaua",
                          locationName: "Waikiki Gateway Park",
                              discipline: "Sculpture",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        mapView.addAnnotation(artwork)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        mapView.showsUserLocation = true;
    }
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(ViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.3
        self.mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    func sendValue(value: NSString) {
        print(value);
    }
    
    func handleLongPress(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .Began{
            return
        }
        
        /*let touchPoint:CGPoint = gestureRecognizer.locationInView(self.mapView)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)*/
        
        //let annot:MKPointAnnotation = MKPointAnnotation()
        
        performSegueWithIdentifier("NotifyModally", sender: nil)
        
        /*let annot = Tag(title: "DELETE THIS",
                          locationName: "DELETE THIS",
                          discipline: "TEST",
                          coordinate: myLocation!)*/
        
        //self.mapView.addAnnotation(annot)
        self.centerMap(myLocation!)
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        myLocation = center
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NotifyModally" {
            
            let secondViewController = segue.destinationViewController as! ModalViewController
            secondViewController.parent = self
        }
    }

}

