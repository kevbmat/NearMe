// Kurt Lamon and Kevin Mattappally
// CPSC 315
// Programming Assignment #8
// Kevin Mattappally
// PlaceTableViewCell.swift

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    // label for the place
    @IBOutlet var placeLabel: UILabel!
    // label for the address
    @IBOutlet var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // updates the the cell with the corresponding place name, rating, and vicinity
    func update(with place: Place) {
        placeLabel.text = "\(place.name) (\(place.rating) \u{2b50})"
        addressLabel.text = "\(place.vicinity)"
    }

}
