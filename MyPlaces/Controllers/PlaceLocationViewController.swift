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
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.coordinate
        mapView.addAnnotation(annotation)
        self.latittudeTextField.text = String(describing:self.place.coordinate.latitude)
        self.longitudeTextField.text = String(describing:self.place.coordinate.longitude)
    }
    
    @IBAction func detectLocationBtnClick(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func saveBtnClick(_ sender: Any) {
        
        if let latitude = Double(latittudeTextField.text!) {
            place.coordinate.latitude = latitude
        }
        if let longitude = Double(longitudeTextField.text!) {
            place.coordinate.longitude = longitude
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count>0 {
            let location = locations[0]
            latittudeTextField.text = String(describing:location.coordinate.latitude)
            longitudeTextField.text = String(describing:location.coordinate.longitude)
            mapView.setCenter(location.coordinate,animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
