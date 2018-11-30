// Kurt Lamon and Kevin Mattappally

import UIKit
import CoreLocation

class PlaceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Fill in completion closure
        let text: String = searchBar.text!
        print(text)
        if text != "" {
            PlaceAPI.fetchPlaces(text: text, location: (latitude: location.latitude, longitude: location.longitude), completion: { (placesOptional) in
                if let placesArray = placesOptional {
                    self.places = placesArray
                }
                self.placeTableView.reloadData()
            })
            print("update pressed")
        }
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
        let text: String = searchBar.text!
        print(text)
        if text != "" {
            PlaceAPI.fetchPlaces(text: text, location: (latitude: location.latitude, longitude: location.longitude), completion: { (placesOptional) in
                if let placesArray = placesOptional {
                    self.places = placesArray
                }
                self.placeTableView.reloadData()
            })
            print("update pressed")
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "DetailSegue" {
                if let detailVC = segue.destination as? PlaceDetailViewController {
                    if let indexPath = placeTableView.indexPathForSelectedRow {
                        let place = places[indexPath.row]
                        detailVC.place = place
                    }
                }
            }
        }
    }
    
    // TODO updateTableView
    func updateUI() {
        
    }
}

