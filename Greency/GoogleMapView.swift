//
//  GoogleMapView.swift
//  Greency
//
//  Created by bayan alshammri on 10/04/2025.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    let markers: [PlaceMarker]
    let userLocation: CLLocationCoordinate2D?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: userLocation?.latitude ?? 24.7136,
            longitude: userLocation?.longitude ?? 46.6753,
            zoom: 13
        )

        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        for markerInfo in markers {
            let marker = GMSMarker(position: markerInfo.coordinate)
            marker.icon = GMSMarker.markerImage(with: .systemPurple)
            marker.map = mapView
            marker.userData = markerInfo
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}

    class Coordinator: NSObject, GMSMapViewDelegate {
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard let info = marker.userData as? PlaceMarker else { return false }

            let latitude = info.coordinate.latitude
            let longitude = info.coordinate.longitude
            if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)") {
                UIApplication.shared.open(url)
            }

            return true
        }
    }
}

