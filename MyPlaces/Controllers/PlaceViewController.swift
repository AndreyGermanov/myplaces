//
//  PlaceViewController.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBAction func takePictureBtnClick(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let selectWindow = UIAlertController(title: "Select", message: "Source type", preferredStyle: .actionSheet)
        selectWindow.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            selectWindow.dismiss(animated: true, completion: nil)
            self.present(imagePicker,animated:true)
            
        }))
        selectWindow.addAction(UIAlertAction(title:"Photo library", style: .default, handler: { (_) in
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            selectWindow.dismiss(animated: true, completion: nil)
            self.present(imagePicker,animated:true)
            
        }))
        self.present(selectWindow,animated:true,completion:nil)
    }
    
    var place: Place?
    
    @IBOutlet weak var placeDetailTable: UITableView!
    
    override func viewDidLoad() {
        placeDetailTable.delegate = self
        placeDetailTable.dataSource = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeDetailTable.reloadData()
        placeDetailTable.setNeedsLayout()
    }
}

extension PlaceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 4
        if let place = self.place {
            count = count + place.photos.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeDateCell", for: indexPath)
            if let place = self.place {
                cell.textLabel?.text = place.date.description
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeTitleCell", for: indexPath) as! PlaceTitleTableViewCell
            if let place = self.place {
                cell.place = place
                if let title = place.title {
                    if (title.count>0) {
                        cell.placeTitleLabel.text = title
                    } else {
                        cell.placeTitleLabel.text = ""
                    }
                }
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeLocationCell", for: indexPath) as! PlaceLocationTableViewCell
            if let place = self.place {
                cell.place = place
                cell.placeLocationLabel.text = ""
                if place.address.count > 0 {
                    cell.placeLocationLabel.text! += place.address
                }
                let latitude = String(describing:place.coordinate.latitude)
                let longitude = String(describing:place.coordinate.longitude)
                if latitude.count > 0 && longitude.count > 0 {
                    cell.placeLocationLabel.text! += "(\(latitude),\(longitude))"
                }
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeDescriptionCell", for: indexPath) as! PlaceDescriptionTableViewCell
            if let place = self.place {
                cell.place = place
                if place.descr.count>0 {
                    cell.placeDescriptionLabel.text = place.descr
                } else {
                    cell.placeDescriptionLabel.text = ""
                }
            }
            return cell
        case 4..<1000:
            let cell = tableView.dequeueReusableCell(withIdentifier: "placePhotosCell", for: indexPath) as! PlacePhotosTableViewCell
            if let place = self.place {
                if indexPath.row-4>=0 && place.photos.count>indexPath.row-4 {
                    let photo = place.photos[indexPath.row-4]
                    cell.photo = photo
                    cell.photoIndex = indexPath.row-4
                    cell.viewController = self
                    cell.photoView.addGestureRecognizer(cell.doubleTapGestureRecognizer)
                    cell.photoView.image = photo.image
                    cell.photoDescriptionLabel.text = photo.description
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Title", message: "Enter new title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            if indexPath.row == 1 {
                textField.text = self.place?.title
            } else if indexPath.row == 3 {
                textField.text = self.place?.descr
            }
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let textFields = alert.textFields {
                let textField = textFields[0]
                if let text = textField.text {
                    if text.count>0 {
                        if (indexPath.row == 1) {
                            self.place!.title = text
                        } else if (indexPath.row == 3) {
                            self.place!.descr = text
                        }
                        self.placeDetailTable.reloadData()
                        self.placeDetailTable.setNeedsLayout()
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoIndex = sender as? Int {
            if let pageView = segue.destination as? PhotosListViewController {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let photoView = storyboard.instantiateViewController(withIdentifier: "photoViewController") as? PhotoViewController {
                    let photo = self.place!.photos[photoIndex]
                    
                    photoView.photo = photo
                    pageView.place = self.place
                    pageView.photoIndex = photoIndex
                    pageView.setViewControllers([photoView], direction: .forward, animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension PlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let alert = UIAlertController(title: "Description", message: "Describe this photo", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "description"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let text = alert.textFields?[0].text {
                if (text.count>0) {
                    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                    let photo = Photo("ph\((self.place?.photos.count)!+1)",place:self.place!)
                    photo.image = image
                    photo.description = text
                    self.place?.photos.append(photo)
                    self.placeDetailTable.reloadData()
                    alert.dismiss(animated: true, completion:nil)
                    picker.dismiss(animated: true, completion: nil)
                }
            }
        }))
        picker.present(alert,animated:true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= 4 {
            return 198.0
        } else {
            return 44.0
        }
    }
    
}
