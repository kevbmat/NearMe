//
//  PlaceAPI.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/26/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import Foundation

struct PlaceAPI {
    static let apiKey: String = "AIzaSyBnyJwxj9eSbZKAUCW_6l1W3HYf8p5azXk"
    
    static func placeURL() -> URL {
        // first lets define our query parameters
        let params = [
            "method": "flickr.interestingness.getList",
            "api_key": PlaceAPI.apiKey,
            "format": "json",
            "nojsoncallback": "1", // ask for raw JSON
            "extras": "date_taken,url_h" // url_h is for a 1600px image url for the photo
        ]
        
        // now we need to get the params into a url with the base url
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        // var components = URLComponents(string: PlaceAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print(url)
        return url
    }
    
}
