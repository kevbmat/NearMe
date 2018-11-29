//
//  ViewController.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/25/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var placeTableView: UITableView!
    var places = [Place]()
    let locationManager = CLLocationManager()
    @IBOutlet var searchBar: UISearchBar!
    var location: (latitude: Double, longitude: Double) = (45.0, 177.0)
    
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
    
    @IBAction func updatePressed(_ sender: UIBarButtonItem) {
        // TODO: Fill in completion closure
        PlaceAPI.fetchPlaces(location: (latitude: location.latitude, longitude: location.longitude), completion: { (placesOptional) in
            if let placesArray = placesOptional {
                self.places = placesArray
                print(self.places)
            }
        })
        print("update pressed")
        placeTableView.reloadData()
    }
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        } else {
            // the user turned off location, phone is in airplane mode, lack of hardware, hardware failure,...
            print("Location services disabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.latitude = locations[0].coordinate.latitude
        location.longitude = locations[0].coordinate.longitude
    }
    
    // TODO updateTableView
    func updateUI() {
        
    }
}

