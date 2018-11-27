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
                    completion(interestingPhotos)
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
    
    static func interestingPhotos(fromData data: Data) -> [InterestingPhoto]? {
        // return nil if we fail to parse the JSON in data
        
        // MARK: - JSON javascript object notation
        // JSON is commonly used to pass around data on the web
        // JSON is really just dictionary
        // keys are strings
        // values are strings, nested JSON objects, arrays, numerics, bools, etc.
        // our goal is to convert the Data object into an [String: Any] a dictionary representing our JSON object
        // swiftyJSON makes this process much simpler.. there are other libraries
        // we are gonna do it the long way!!
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            // now convert it to a dictionary!!
            guard let jsonDictionary = jsonObject as? [String: Any], let photoObject = jsonDictionary["photos"] as? [String: Any], let photoArray = photoObject["photo"] as? [[String: Any]] else {
                print("Error parsing JSON")
                return nil
            }
            // we have photoarray!!
            // array of json objects
            var interestingPhotos = [InterestingPhoto]()
            for photoJSON in photoArray {
                // goal is to try and get an InterestingPhoto for each photoJSON
                // task: call interestingPhoto(fromJSON:)
                if let interestingPhoto = interestingPhoto(fromJSON: photoJSON) {
                    print("Got a photo back!")
                    interestingPhotos.append(interestingPhoto)
                }
                // if the return value is not nil
                // put it in array [InterestingPhoto]
            }
            if !interestingPhotos.isEmpty {
                return interestingPhotos
            }
            
        } catch {
            print("Error getting a JSON object \(error)")
        }
        return nil
    }
    
    static func interestingPhoto(fromJSON json: [String: Any]) -> InterestingPhoto? {
        // return nil if parsing fails
        guard let id = json["id"] as? String, let title = json["title"] as? String, let dateTaken = json["datetaken"] as? String, let url = json["url_h"] as? String else {
            print("Error parsing photo")
            return nil
        }
        // task: grab the title, datetaken, url
        // return an InterestingPhoto
        return InterestingPhoto(id: id, title: title, dateTaken: dateTaken, photoURL: url)
    }
    
    
    // MARK: - Fetch Image
    static func fetchImage(fromURLString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: fromURLString)!
        // now we want to get Data back from a request using this url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                print("we got a UIImage!!")
                DispatchQueue.main.async {
                    completion(image)
                }
                // should also call completion(nil) on failure
            }
            else {
                if let error = error {
                    print("Error getting an image \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
}
