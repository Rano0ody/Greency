//
//  LocationTabView.swift
//  Greency
//
//  Created by bayan alshammri on 10/04/2025.
//

import SwiftUI
import CoreLocation

struct LocationTabView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab: String? = "Map"

    let binLocations: [PlaceMarker] = [
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.6514038, longitude: 46.8243712)),
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.6519085, longitude: 46.840193)),
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.6160149, longitude: 46.8631036)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.618115, longitude: 46.8211792)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.6506066, longitude: 46.8362253)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.5965723, longitude: 46.8608449)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.7105467, longitude: 46.6676262)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.8227222, longitude: 46.6194109)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.6750278, longitude: 46.6256389)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.7683611, longitude: 46.6066609)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.7683611, longitude: 46.6066609)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.7528611, longitude: 46.5872165)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.5526111, longitude: 46.8916609)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.6042222, longitude: 46.6524109)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.8135278, longitude: 46.7710776)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.8369167, longitude: 46.7448554)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.8084722, longitude: 46.6716331)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.8405556, longitude: 46.7349109)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.7998056, longitude: 46.8166331)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.8543056, longitude: 46.8917998)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.73825, longitude: 46.7265498)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.65825, longitude: 46.7859387)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.9576944, longitude: 46.7063276)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.9576944, longitude: 46.7063276)) ,
        PlaceMarker(coordinate: CLLocationCoordinate2D(latitude: 24.5866111, longitude: 46.7626331)) ,
    ]
    
    var body: some View {        
        ZStack {
            GoogleMapView(
                markers: binLocations,
                userLocation: locationManager.location
            )
            .ignoresSafeArea()
            
            VStack {
                            Spacer()
                            CustomTabBar(selectedTab: $selectedTab)
                        }
                        .edgesIgnoringSafeArea(.bottom)

                        // روابط التنقل بين التابات
                        NavigationLink(destination: HomePageView(), tag: "Home", selection: $selectedTab) {
                            EmptyView()
                        }
                        NavigationLink(destination: ContentView(), tag: "Camera", selection: $selectedTab) {
                            EmptyView()
                        }
                        NavigationLink(destination: LocationTabView(), tag: "Map", selection: $selectedTab) {
                            EmptyView()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
