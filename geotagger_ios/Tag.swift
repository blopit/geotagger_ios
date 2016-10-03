//
//  Tag.swift
//  geotagger_ios
//
//  Created by Shrenil Patel on 2016-10-01.
//  Copyright © 2016 ___SHRENILPATEL___. All rights reserved.
//

import Foundation
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class Tag: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func pinColor() -> MKPinAnnotationColor  {
        switch discipline {
        case "Emergency", "Service":
            return .Red
        case "Structure", "Scenery":
            return .Purple
        default:
            return .Green
        }
    }
}