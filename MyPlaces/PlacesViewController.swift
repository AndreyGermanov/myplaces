//
//  PlacesViewController.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 24.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// View Controller for Places List screen

import UIKit
import MapKit

class PlacesViewController: UIViewController {

    @IBOutlet weak var placesMap: MKMapView!
    
    @IBOutlet weak var placesTableView: UITableView!
    
    @IBOutlet weak var toggleMapButton: UIBarButtonItem!

    override func viewDidLoad() {
        view.translatesAutoresizingMaskIntoConstraints = false
        if placesMap.isHidden {
            placesTableView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!)
            toggleMapButton.title = "Show Map"
        } else {
            placesTableView.topAnchor.constraint(equalTo: placesMap.bottomAnchor)
            toggleMapButton.title = "Hide Map"
        }
        super.viewDidLoad()
    }
    
    @IBAction func toggleMapButtonClick(_ sender: Any) {
        if placesMap.isHidden {
            placesMap.isHidden = false
            placesTableView.topAnchor.constraint(equalTo: placesMap.bottomAnchor)
            toggleMapButton.title = "Hide map"
        } else  {
            placesMap.isHidden = true
            placesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            toggleMapButton.title = "Show map"
        }
    }
}
