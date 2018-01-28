//
//  Application.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class Application: NSObject {
    
    static let shared: Application = Application()
    
    var places: [Place] = [Place]()
    
    override private init() {
        super.init()
        let place = Place("p1")
        place.title = "My best place"
        places.append(place)
        let place2 = Place("p2")
        place2.title = "Just simple place"
        places.append(place2)
    }
    
    func addPlace(_ title: String) {
        let place = Place("p\(places.count+1)")
        place.title = title
        places.append(place)
    }
    
    func removePlace(_ index: Int) {
        if index < self.places.count {
            self.places.remove(at: index)
        }
    }
    
}
