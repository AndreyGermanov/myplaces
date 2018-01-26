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
        //imagePicker.cameraCaptureMode = .photo
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker,animated:true)
    }
    
    var place: Place?
    
    @IBOutlet weak var placeDetailTable: UITableView!
    
    override func viewDidLoad() {
        placeDetailTable.delegate = self
        placeDetailTable.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeDetailTable.reloadData()
    }
}

extension PlaceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 4 + self.place!.photos.count
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
                    cell.placeDescriptionLabel.text = "descipt"
                }
            }
            return cell
        case 4..<1000:
            let cell = tableView.dequeueReusableCell(withIdentifier: "placePhotosCell", for: indexPath) as! PlacePhotosTableViewCell
            if let place = self.place {
                cell.place = place
                if indexPath.row-4>=0 && place.photos.count>indexPath.row-4 {
                    let photo = place.photos[indexPath.row-4]
                    cell.photoView.image = photo.image
                    cell.photoDescriptionLabel.text = photo.description
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension PlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let photo = Photo("ph1",place:self.place!)
        photo.image = image
        place?.photos.append(photo)
        placeDetailTable.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
