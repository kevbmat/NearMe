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
