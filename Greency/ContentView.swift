//
//  ContentView.swift
//  Greency
//
//  Created by Rand abdullatif on 11/10/1446 AH.
//
import SwiftUI
import AVFoundation
import Vision
import CoreML
import CoreLocation

// MARK: - ContentView

struct ContentView: View {
    @State private var capturedImage: UIImage?
    @State private var materialLabel: String = ""
    @State private var showPopup: Bool = false
    @State private var selectedTab: String? = "Camera"
    @State private var navigateToProfile = false
    
    var body: some View {
        ZStack {
            CameraView { image in
                if let image = image {
                    self.capturedImage = image
                    classifyImage(image)
                }
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        NotificationCenter.default.post(name: .capturePhoto, object: nil)
                    }) {
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal)
               .padding(.bottom, 150)

            }

               VStack {
                   Spacer()
                  
                       .background(Color.white)
                       .edgesIgnoringSafeArea(.bottom)

               }

            if showPopup {
                CustomResultView(label: materialLabel) {
                    showPopup = false
                    capturedImage = nil
                }
                .zIndex(1)
            }
            NavigationLink(destination: ContentView(), tag: "Camera", selection: $selectedTab) {
                            EmptyView()
                        }
                        NavigationLink(destination: LocationTabView(), tag: "Map", selection: $selectedTab) {
                            EmptyView()
                        }
            NavigationLink(destination: HomePageView(), tag: "Home", selection: $selectedTab) {
                            EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func classifyImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            showUnrecognized()
            return
        }

        guard let model = try? VNCoreMLModel(for: Greency_1().model) else {
            showUnrecognized()
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first, topResult.confidence > 0.5 else {
                showUnrecognized()
                return
            }

            DispatchQueue.main.async {
                self.materialLabel = topResult.identifier.capitalized
                self.showPopup = true
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    func showUnrecognized() {
        DispatchQueue.main.async {
            self.materialLabel = "Unknown"
            self.showPopup = true
        }
    }
}

// MARK: - CustomResultView

struct CustomResultView: View {
    let label: String
    var onDismiss: () -> Void

    // مواقع الحاويات
    let binLocations = [
        CLLocationCoordinate2D(latitude: 24.6514038, longitude: 46.8243712),
        CLLocationCoordinate2D(latitude: 24.6519085, longitude: 46.840193),
        CLLocationCoordinate2D(latitude: 24.6160149, longitude: 46.8631036),
        CLLocationCoordinate2D(latitude: 24.618115, longitude: 46.8211792),
        CLLocationCoordinate2D(latitude: 24.6506066, longitude: 46.8362253),
        CLLocationCoordinate2D(latitude: 24.5965723, longitude: 46.8608449),
        CLLocationCoordinate2D(latitude: 24.7105467, longitude: 46.6676262),
        CLLocationCoordinate2D(latitude: 24.8227222, longitude: 46.6194109),
        CLLocationCoordinate2D(latitude: 24.6750278, longitude: 46.6256389),
        CLLocationCoordinate2D(latitude: 24.7683611, longitude: 46.6066609),
        CLLocationCoordinate2D(latitude: 24.7683611, longitude: 46.6066609),
        CLLocationCoordinate2D(latitude: 24.7528611, longitude: 46.5872165),
        CLLocationCoordinate2D(latitude: 24.5526111, longitude: 46.8916609),
        CLLocationCoordinate2D(latitude: 24.6042222, longitude: 46.6524109),
        CLLocationCoordinate2D(latitude: 24.8135278, longitude: 46.7710776),
        CLLocationCoordinate2D(latitude: 24.8369167, longitude: 46.7448554),
        CLLocationCoordinate2D(latitude: 24.8084722, longitude: 46.6716331),
        CLLocationCoordinate2D(latitude: 24.8405556, longitude: 46.7349109),
        CLLocationCoordinate2D(latitude: 24.7998056, longitude: 46.8166331),
        CLLocationCoordinate2D(latitude: 24.8543056, longitude: 46.8917998),
        CLLocationCoordinate2D(latitude: 24.73825, longitude: 46.7265498),
        CLLocationCoordinate2D(latitude: 24.65825, longitude: 46.7859387),
        CLLocationCoordinate2D(latitude: 24.9576944, longitude: 46.7063276),
        CLLocationCoordinate2D(latitude: 24.9576944, longitude: 46.7063276),
        CLLocationCoordinate2D(latitude: 24.5866111, longitude: 46.7626331)
    ]


    var body: some View {
        VStack {
            Spacer()

            ZStack {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)

                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 16) {
                        Image(systemName: isUnknown ? "xmark.circle" : "checkmark.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(isUnknown ? Color(red: 224/255, green: 32/255, blue: 32/255) : Color(red: 112/255, green: 203/255, blue: 0/255))

                        Text(isUnknown ? "Unknown" : "It's \(label)")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(isUnknown ? "You can't Recycle" : "You can Recycle")
                            .foregroundColor(.gray)
                            .font(.subheadline)

                        if !isUnknown {
                            Button(action: openNearestBinInMaps) {
                                HStack(spacing: 6) {
                                    Text("Check the nearest bin")
                                    Image(systemName: "location")
                                }
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color(red: 97/255, green: 67/255, blue: 222/255))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .frame(width: 230, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 8)

                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.black)
                            .padding(12)
                    }
                }
            }

            Spacer()
        }
    }

    func openNearestBinInMaps() {
        guard let userLocation = CLLocationManager().location?.coordinate else { return }

        let nearest = getNearestBin(from: userLocation)
        let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(nearest.latitude),\(nearest.longitude)")!
        UIApplication.shared.open(url)
    }

    func getNearestBin(from userLocation: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        return binLocations.min(by: {
            let loc1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let loc2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
            return userLoc.distance(from: loc1) < userLoc.distance(from: loc2)
        })!
    }

    var isUnknown: Bool {
        label.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "unknown"
    }
}

