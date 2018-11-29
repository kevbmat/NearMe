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
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let dataString = String(data: data, encoding: .utf8), let places = places(fromData: data) {
                print("success")
                DispatchQueue.main.async {
                    completion(places)
                }
            } else {
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
            print(jsonObject)
            guard let jsonDictionary = jsonObject as? [String: Any], let placeObject = jsonDictionary["results"] as? [[String: Any]] else {
                print("Error parsing JSON")
                return nil
            }
            
        } catch {
            print("error getting JSON")
        }
        return nil
    }
}
