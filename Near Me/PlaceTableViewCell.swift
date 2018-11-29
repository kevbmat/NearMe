//
//  PlaceTableViewCell.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/25/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with place: Place) {
        placeLabel.text = "\(place.name) (\(place.rating) stars)"
        addressLabel.text = "\(place.vicinity)"
    }

}
