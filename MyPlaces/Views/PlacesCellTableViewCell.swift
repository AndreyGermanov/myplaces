//
//  PlacesCellTableViewCell.swift
//  MyPlaces
//
//  Created by Andrey Germanov on 25.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

import UIKit

class PlacesCellTableViewCell: UITableViewCell {

    @IBOutlet weak var placeTitleLabel: UILabel!
    
    var place: Place?
    var placesController: PlacesViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
