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
    var myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.472839, longitude: -80.543185)
    
    var name: NSString = ""
    var cat: NSString = ""
    var subcat: NSString = ""
    var desc: NSString = ""
    
    var user: NSString = "Shrenil"
    var token: NSString = "c5fd8c022bad0d53679730a2e0d40c7f933e9fffccc6fb8c109832169864ade5ee59f12a1863d342127de144d0ebd472e9e5eacb17672abd0aed609261f4402eb2bb5164f96c70dbc5e31fd1f1cd34a2c20fc7cbed669c07f625fbe95d15b4d147bcdc782aa4603b28c8ef630be88f75b3b2986a8e2775acf4257349b8b35002b98a1a7f2d91f650a5fedf5e916f9aa8955e7744703b8302319c0af0dc80b040ac59f509d8d5f4d75b790856684be368af6b94eaccae474e282e00a382c1713f45d52b0b6ce2271accb706bd2d8fed53e4d59e00154a39fdba6fdc489ba4a2c4075e68a9eb5ad9ca08686e554096c089134d5349f65b95d8c95bfd91fc7a971c"
    var jsondata: NSData = NSData()
    
    func getAllTags() {
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        let url = NSURL(string: String(format: "https://geotaganything.herokuapp.com/tags?latitude=%f&longitude=%f", Float(myLocation.latitude), Float(myLocation.longitude)))
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.jsondata = data!
            
            let json = self.nsdataToJSON(data!)
            for item in json as! [Dictionary<String, AnyObject>] {
                let coord = item["location"]!["coordinates"] as! Array<CLLocationDegrees>
                let tag = Tag(title: item["name"] as! String,
                            locationName: item["subcategory"] as! String,
                            discipline: item["category"] as! String,
                            coordinate: CLLocationCoordinate2D(latitude:coord[0] , longitude: coord[1]))
                
                self.mapView.addAnnotation(tag)
            }
            
        }
        
        task.resume()
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
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
        
        getAllTags();
        
        
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
    
    func sendValue() {
        print(name);
        
        let annot = Tag(title: name as String,
                        locationName: subcat as String,
                        discipline: cat as String,
                        coordinate: myLocation)
        self.mapView.addAnnotation(annot)
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
        
        self.centerMap(myLocation)
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        getAllTags();
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

