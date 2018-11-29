//
//  PlaceAPI.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/26/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import Foundation

struct PlaceAPI {
    static let apiKey: String = "AIzaSyDJgGQcEca-T1jl0dtxcqPLgkZTi_MAEtQ"
    static let baseURL: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    
    static func placeURL(location: (latitude: Double, longitude: Double)) -> URL {
        // first lets define our query parameters
        let params: [String: String] = [
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
        print(url)
        return url
    }
    
    static func fetchPlaces(location: (latitude: Double, longitude: Double), completion: @escaping ([Place]?) -> Void) {
        let url = placeURL(location: location)
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let dataString = String(data: data, encoding: .utf8), let places = places(fromData: data) {
                print(dataString)
                DispatchQueue.main.async {
                    completion(places)
                }
            } else {
                print("yeet")
                if let error = error {
                    print("error")
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
            // print(jsonObject)
            guard let jsonDictionary = jsonObject as? [String: Any], let placeArray = jsonDictionary["results"] as? [[String: Any]] else {
                print("Error parsing JSON")
                return nil
            }
            print("we have json dictionary")
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
