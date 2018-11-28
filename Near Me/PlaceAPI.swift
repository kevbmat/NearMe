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
    static let baseURL: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/"
    
    static func placeURL() -> URL {
        // first lets define our query parameters
        let params: [String: Any] = [
            "key": PlaceAPI.apiKey,
            "location": "sample",
            "radius": "500"
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
    
}
