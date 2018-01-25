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

    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var placesMap: MKMapView!
    
    @IBOutlet weak var placesTable: UITableView!
    
    @IBOutlet weak var toggleMapButton: UIBarButtonItem!
    var mapEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.height
        mapHeightConstraint.constant = screenHeight / 2.0
        view.layoutIfNeeded()
        placesTable.delegate = self
        placesTable.dataSource = self
        placesTable.isEditing = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func orientationChanged() {
        let screenHeight = view.frame.height
        if (mapEnabled) {
            self.mapHeightConstraint.constant = screenHeight / 2.0
        } else {
            self.mapHeightConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func toggleMapButtonClick(_ sender: Any) {
        let screenHeight = view.frame.height
        if (mapEnabled) {
            self.toggleMapButton.title = "Show map"
            self.mapEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.mapHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            self.toggleMapButton.title = "Hide map"
            self.mapEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.mapHeightConstraint.constant = screenHeight/2.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetailView" {
            if let place = sender as? Place {
                (segue.destination as? PlaceViewController)!.place = place
            }
        }
    }
}

extension PlacesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Application.shared.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for:indexPath) as! PlacesCellTableViewCell
        cell.placeTitleLabel.text = Application.shared.places[indexPath.row].title
        cell.place = Application.shared.places[indexPath.row]
        cell.placesController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            Application.shared.removePlace(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let place = Application.shared.places[indexPath.row]
        self.performSegue(withIdentifier: "placeDetailView", sender: place)
    }
}
