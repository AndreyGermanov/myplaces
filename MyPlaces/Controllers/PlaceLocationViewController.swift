//
//  PlaceLocationControllerViewController.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 30.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceLocationViewController: UIViewController {

    var activeTextField: UITextField?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var searchResults: UISearchDisplayController!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var latittudeTextField: UITextField!
    
    @IBOutlet weak var longitudeTextField: UITextField!
    
    var place: Place!
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTextField.delegate = self
        latittudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.setRegion(MKCoordinateRegion.init(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPlacemark(coordinate: place.coordinate)
        
        mapView.addAnnotation(annotation)
        self.latittudeTextField.text = String(describing:self.place.coordinate.latitude)
        self.longitudeTextField.text = String(describing:self.place.coordinate.longitude)
        self.addressTextField.text = self.place.address
    }
    
    @IBAction func detectLocationBtnClick(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func saveBtnClick(_ sender: Any) {
        
        if let latitude = Double(latittudeTextField.text!) {
            place.coordinate.latitude = (latitude*1000).rounded()/1000
        }
        if let longitude = Double(longitudeTextField.text!) {
            place.coordinate.longitude = (longitude*1000).rounded()/1000
        }
        if let address = addressTextField.text {
            place.address = address
        }
        self.dismiss(animated: true, completion:nil)
        
    }
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
}

//MARK: Text fields delegate
extension PlaceLocationViewController: UITextFieldDelegate {
    
    // Function dismisses onscreen keyboard when user touches screen (out of text fields)
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Function dismisses onscreen keyboard when user presses "Return" button on it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Method fires when user focues input field. It sets active field parameter for future use
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let latitude = Double(latittudeTextField.text!) {
            if let longitude = Double(longitudeTextField.text!) {
                print(latitude)
                print(longitude)
                mapView.removeAnnotations(mapView.annotations)
                let annotation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                mapView.addAnnotation(annotation)
                mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude),animated:true)
            }
        }
        return true
    }
    
    // Method fire when onscreen keyboard begins to appear on screen. It calculates to which distance need to scroll
    // screen to make sure that onscreen keyboard not overlap active text field and scrolls screen to this position
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            let input_field_origin = activeTextField!.convert(activeTextField!.frame.origin, to: self.view)
           // if self.view.frame.height-keyboardSize.height<(input_field_origin.y+activeTextField!.frame.height) {
                self.view.frame.origin.y = self.view.frame.origin.y -
                    (activeTextField!.superview?.frame.origin.y)!+self.view.safeAreaInsets.top*2+10
            
            //}
        }
    }
    
    // Method fire when onscreen keyboard dismissed. It scrolls screen back to initial position
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension PlaceLocationViewController: CLLocationManagerDelegate {
    func getAddressString(_ address: CLPlacemark) -> String {
        var addressString = ""
        if let country = address.country {
            addressString = addressString + "\(country) "
        }
        if let postCode = address.postalCode {
            addressString = addressString + "\(postCode) "
        }
        if let locality = address.locality {
            addressString = addressString + "\(locality) "
        }
        if let subLocality = address.subLocality {
            addressString = addressString + "\(subLocality) "
        }
        return addressString
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count>0 {
            let location = locations[0]
            latittudeTextField.text = String(describing:location.coordinate.latitude)
            longitudeTextField.text = String(describing:location.coordinate.longitude)
            mapView.setCenter(location.coordinate,animated: true)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks,error) in
                if let addresses = placemarks {
                    if (addresses.count>0) {
                        let address = addresses[0]
                        self.addressTextField.text = self.getAddressString(address)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
