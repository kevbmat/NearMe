//
//  PlaceDetailViewController.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/25/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    var place: Place? = nil
    
    @IBOutlet var nameAndOpenLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var placeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let validPlace = place {
            PlaceAPI.fetchDetails(place: validPlace, completion: {(placeDetailOptional) in
                if let placeDetail = placeDetailOptional {
                    self.descriptionLabel.text = placeDetail.description
                    self.phoneNumberLabel.text = placeDetail.phoneNumber
                } else {
                    print("sad yeet")
                }
            })
            nameAndOpenLabel.text = validPlace.name
            addressLabel.text = validPlace.vicinity
            placeImage.image = UIImage(named: validPlace.photoReference)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
