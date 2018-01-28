//
//  PlacePhotosTableViewCell.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class PlacePhotosTableViewCell: UITableViewCell {

    var photo: Photo?
    var photoIndex = 0
    var viewController: PlaceViewController!
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
    }

    @IBAction func deleteBtnClick(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.photo!.place.removePhoto(self.photo!.id)
            self.viewController.placeDetailTable.reloadData()
            self.viewController.placeDetailTable.setNeedsLayout()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.viewController.present(alert,animated: true)
    }
    
    @objc func imageDoubleTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            self.viewController.performSegue(withIdentifier: "photoViewSegue", sender: photoIndex)
        }
    }
    
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
