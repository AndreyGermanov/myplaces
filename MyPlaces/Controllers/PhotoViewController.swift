//
//  PhotoViewController.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var photo: Photo?
    var place: Place?
    var photoIndex = 0
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = self.photo {
            self.imageView.image = photo.image
            self.descriptionText.text = photo.description
        }
        self.descriptionText.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tapGestureRecognier = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.view.addGestureRecognizer(tapGestureRecognier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let place = self.photo?.place {
            self.place = place
        }
        super.viewDidAppear(animated)
        if let photo = self.photo {
            self.imageView.image = photo.image
            self.descriptionText.text = photo.description
        }
    }

    @IBAction func editBtnClick(_ sender: Any) {
        photo?.description = self.descriptionText.text
        let alert = UIAlertController(title: "Success", message: "Your changes saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated:true)
    }
}

//MARK: Text fields delegate
extension PhotoViewController: UITextViewDelegate {
    
    // Function dismisses onscreen keyboard when user touches screen (out of text fields)
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Function dismisses onscreen keyboard when user presses "Return" button on it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Method fire when onscreen keyboard begins to appear on screen. It calculates to which distance need to scroll
    // screen to make sure that onscreen keyboard not overlap active text field and scrolls screen to this position
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let activeTextField = self.descriptionText
            self.view.frame.origin.y = 0
            let input_field_origin = activeTextField!.convert(activeTextField!.frame.origin, to: self.view)
            if self.view.frame.height-keyboardSize.height-(self.navigationController?.navigationBar.frame.height)!<(input_field_origin.y+activeTextField!.frame.height) {
                self.view.frame.origin.y = self.view.frame.origin.y -
                    keyboardSize.height
            }
        }
    }
    
    // Method fire when onscreen keyboard dismissed. It scrolls screen back to initial position
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
}
