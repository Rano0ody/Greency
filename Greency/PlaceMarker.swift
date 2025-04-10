//
//  PlaceService.swift
//  Greency
//
//  Created by bayan alshammri on 10/04/2025.
//

import CoreLocation

struct PlaceMarker {
    let coordinate: CLLocationCoordinate2D
}

struct RecyclingCenter {
    let coordinate: CLLocationCoordinate2D
    let materialTypes: [String] // مثل ["Plastic", "Paper", "Glass"]
}
