//
//  HomePageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//
//


import SwiftUI
import SwiftData

struct HomePageView: View {
    @AppStorage("loggedInEmail") var loggedInEmail: String = ""
    @AppStorage("profileImageData") var profileImageData: String = ""
    @Query private var users: [UserData]
    @State private var navigateToProfile = false
    @State private var selectedTab: String? = "Home"

    
    var currentUser: UserData? {
        users.first { $0.email == loggedInEmail }
    }

    var body: some View {
        let userName = currentUser?.firstName ?? "Guest"
        let lastName = currentUser?.lastName ?? ""
        
        NavigationStack {
            VStack(spacing: 0) {
                header(userName: userName, lastName: lastName)
                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: GlassPageView()) {
                            CategoryCard(title: "Glass", imageName: "glass")
                        }
                        NavigationLink(destination: PlasticPageView()) {
                            CategoryCard(title: "Plastic", imageName: "plastic")
                        }
                        NavigationLink(destination: PaperPageView()) {
                            CategoryCard(title: "Paper", imageName: "paper")
                        }
                    }
                    .padding()
                }
                CustomTabBar(selectedTab: $selectedTab)
                
                NavigationLink(destination: ContentView(), tag: "Camera", selection: $selectedTab) {
                    EmptyView()
                }
                NavigationLink(destination: LocationTabView(), tag: "Map", selection: $selectedTab) {
                    EmptyView()
                }
               NavigationLink(destination: profileView(), isActive: $navigateToProfile) {
                    EmptyView()
                }
            }
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
        }
    }

    private func header(userName: String, lastName: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome")
                    .font(.largeTitle)
                    .bold()

                HStack {
                    Text("Good Evening")
                    Text("\(userName) \(lastName)")
                        .foregroundColor(Color("MainPurple"))
                }
                .font(.title3)
            }

            Spacer()

            Button(action: {
                navigateToProfile = true
            }) {
                if let image = UIImage.fromBase64(profileImageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct CategoryCard: View {
    var title: String
    var imageName: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
                .shadow(radius: 5)

            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.white.opacity(0.8))
                .padding()
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: String?
    
    var body: some View {
        HStack {
            Spacer()
            tabItem(title: "Home", systemName: "house")
            
            Spacer()
            tabItem(title: "Camera", systemName: "camera")
            
            Spacer()
            tabItem(title: "Map", systemName: "location")
            
            Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom, 25 )
        .background(Color.white)
    }
    
    private func tabItem(title: String, systemName: String) -> some View {
        VStack {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .foregroundColor(selectedTab == title ? Color("MainBlue") : .gray)
            
            Text(title)
                .font(.caption)
                .foregroundColor(selectedTab == title ? Color("MainBlue") : .gray)
        }
        .onTapGesture {
            selectedTab = title
        }
    }
}

#Preview {
    HomePageView()
}
