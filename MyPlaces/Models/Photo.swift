//
//  Photo.swift
//  MyPlaces
//
//  Created by user on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class Photo {
    
    let id: String
    var image: UIImage = UIImage()
    var description: String = ""
    let place: Place
    
    init(_ id:String,place:Place) {
        self.id = id
        self.place = place
    }
}
