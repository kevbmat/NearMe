// Kurt Lamon and Kevin Mattappally

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
        placeLabel.text = "\(place.name) (\(place.rating) \u{2b50})"
        addressLabel.text = "\(place.vicinity)"
    }

}
