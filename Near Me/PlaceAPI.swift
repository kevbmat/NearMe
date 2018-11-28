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
    static let baseURL: String = "https://maps.googleapis.com/maps/api/place/findplacefromtext/"
    
    static func placeURL() -> URL {
        // first lets define our query parameters
        let params = [
            "key": PlaceAPI.apiKey,
            "input": "sample",
            "inputtype": "textquery"
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
    
    static func fetchPlace(completion: @escaping ([Place]?) -> Void) {
        let url = PlaceAPI.placeURL()
        // now we want to get Data back from a request using this url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // closure executes when this task gets a reponse back from the server
            // could be an error!!
            // see if we got data
            if let data = data, let dataString = String(data: data, encoding: .utf8), let places = interestingPhotos(fromData: data) {
                print("Got a [Place] array")
                DispatchQueue.main.async {
                    completion(Places)
                }
                // should also call completion(nil) on failure
            }
            else {
                if let error = error {
                    print("Error getting photos JSON response \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        // by default when you create a task it starts in the suspended state
        // call resume() to start it
        task.resume()
    }

}
