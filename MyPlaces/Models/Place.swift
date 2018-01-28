//
//  Place.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject,MKAnnotation  {

    let id: String
    var title: String?
    var address: String = ""
    var descr: String = ""
    var date: NSDate = NSDate(timeIntervalSinceNow: 0)
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var photos: [Photo] = [Photo]()
    
    init(_ id: String) {
        self.id = id
    }
    
    func removePhoto(_ id: String) {
        var counter = 0;
        for var photo in photos {
            if photo.id == id {
                self.photos.remove(at: counter)
                break
            }
            counter = counter + 1
        }
    }
}
