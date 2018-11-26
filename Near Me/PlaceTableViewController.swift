//
//  ViewController.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/25/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var places = [Place]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return places.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let place = places[indexPath.row]
        cell.update(with: place)
        // cell.showsReorderControl = true
        return cell
    }
    
    
    @IBOutlet var searchBar: UISearchBar!
    let apiKey: String = "AIzaSyBnyJwxj9eSbZKAUCW_6l1W3HYf8p5azXk"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

