// Kurt Lamon and Kevin Mattappally
// CPSC 315
// Programming Assignment #8
// Kevin Mattappally
// PlaceAPI.swift

import Foundation
import UIKit

struct PlaceAPI {
    static let apiKey: String = "AIzaSyDJgGQcEca-T1jl0dtxcqPLgkZTi_MAEtQ"
    static let baseURL: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    static let baseDetailsURL: String = "https://maps.googleapis.com/maps/api/place/details/json?"
    static let basePhotoURL: String = "https://maps.googleapis.com/maps/api/place/photo?"
    
    
    static func detailURL(id: String) -> URL {
        // first lets define our query parameters
        let params: [String: String] = [
            "key": PlaceAPI.apiKey,
            "placeid": id,
            ]
        
        // now we need to get the params into a url with the base url
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(string: PlaceAPI.baseDetailsURL)!
        components.queryItems = queryItems
        let url = components.url!
        return url
    }
    
    static func photoURL(photoReference: String) -> URL {
        // first lets define our query parameters
        let params: [String: String] = [
            "key": PlaceAPI.apiKey,
            "photoreference": photoReference,
            "maxwidth": "300"
            ]
        
        // now we need to get the params into a url with the base url
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(string: PlaceAPI.basePhotoURL)!
        components.queryItems = queryItems
        let url = components.url!
        return url
    }
    
    // fetches the photo for the detailed view using the API
    static func fetchPhoto(photoReference: String, completion: @escaping (UIImage?) -> Void) {
        let url = photoURL(photoReference: photoReference)
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                if let error = error {
                    print("error details, \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    // fetches the details for the detailed view
    static func fetchDetails(place: Place, completion: @escaping (PlaceDetail?) -> Void) {
        let id = place.id
        let url = detailURL(id: id)
        // print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,let _ = String(data: data, encoding: .utf8), let placeDetail = placesDetails(fromData: data, placeForDetails: place) {
                DispatchQueue.main.async {
                    completion(placeDetail)
                }
            } else {
                if let error = error {
                    print("error details, \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    static func placesDetails(fromData data: Data, placeForDetails: Place) -> PlaceDetail? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String: Any], let result = jsonDictionary["result"] as? [String: Any] else {
                print("Error parsing JSON")
                return nil
            }
            
            // now we have the json dictionary array
            let placeDetail: PlaceDetail? = detail(fromJSON: result, place: placeForDetails)
            return placeDetail
        } catch {
            print("error getting JSON")
        }
        return nil
    }
    
    static func detail(fromJSON json: [String: Any], place: Place) -> PlaceDetail? {
        guard let phoneNumber = json["formatted_phone_number"] as? String else {
            return nil
        }
        guard let reviews = json["reviews"] as? [[String: Any]] else {
            return nil
        }
        guard let description = reviews[0]["text"] as? String else {
            return nil
        }
        let placeDetail = PlaceDetail(place: place, phoneNumber: phoneNumber, description: description)
        return placeDetail
    }
    
    static func placeURL(text: String, location: (latitude: Double, longitude: Double)) -> URL {
        // first lets define our query parameters
        let params: [String: String] = [
            "keyword": text,
            "key": PlaceAPI.apiKey,
            "location": "\(location.latitude),\(location.longitude)",
            "radius": "5000"
        ]
        
        // now we need to get the params into a url with the base url
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(string: PlaceAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        return url
    }
    
    // fetches the places to be shown up on the table view
    static func fetchPlaces(text: String, location: (latitude: Double, longitude: Double), completion: @escaping ([Place]?) -> Void) {
        let url = placeURL(text: text, location: location)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let _ = String(data: data, encoding: .utf8), let places = places(fromData: data) {
                DispatchQueue.main.async {
                    completion(places)
                }
            } else {
                if let error = error {
                    print("error, \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    static func places(fromData data: Data) -> [Place]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String: Any], let placeArray = jsonDictionary["results"] as? [[String: Any]] else {
                print("Error parsing JSON")
                return nil
            }
            // now we have the json dictionary array
            var places = [Place]()
            for placeJSON in placeArray {
                if let p = place(fromJSON: placeJSON) {
                   places.append(p)
                }
            }
            if !places.isEmpty {
                return places
            }
        } catch {
            print("error getting JSON")
        }
        return nil
    }
    
    // gets each property for the place to be shown
    static func place(fromJSON json: [String: Any]) -> Place? {
        guard let id = json["place_id"] as? String else {
            return nil
        }
        guard let name = json["name"] as? String else {
            return nil
        }
        guard let rating = json["rating"] as? Double else {
            return nil
        }
        guard let vicinity = json["vicinity"] as? String else {
            return nil
        }
        guard let photos = json["photos"] as? [[String: Any]] else {
            return nil
        }
        guard let photoReference = photos[0]["photo_reference"] as? String else {
            return nil
        }
        let p = Place(id: id, name: name, rating: "\(rating)", vicinity: vicinity, photoReference: photoReference)
        return p
    }
}
