//
//  Place.swift
//  Near Me
//
//  Created by Kevin Mattappally on 11/25/18.
//  Copyright © 2018 Kevin Mattappally. All rights reserved.
//

import Foundation

class Place {
    var id: String
    var name: String
    var rating: String
    var vicinity: String
    var photoReference: String
    
    init(id: String, name: String, rating: String, vicinity: String, photoReference: String) {
        self.id = id
        self.name = name
        self.rating = rating
        self.vicinity = vicinity
        self.photoReference = photoReference
    }
}
