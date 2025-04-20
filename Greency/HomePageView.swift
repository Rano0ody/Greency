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
    @Query private var users:[UserData]
    @State private var selectedTab: String = "Home"  // إضافة متغير selectedTab هنا
    
    var body: some View {
        let userName = users.first?.firstName ?? "Guest"
        VStack(spacing: 0) {
            header(userName: userName)
            
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
            
            CustomTabBar(selectedTab: $selectedTab)  // تمرير الـ selectedTab كـ Binding
        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func header(userName: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome")
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    Text("Good Evening")
                    Text(userName)
                        .foregroundColor(Color("MainPurple"))
                }
                .font(.title3)
            }
            
            Spacer()
            
            // تم إزالة زر العودة هنا
            NavigationLink(destination: profileView().navigationBarBackButtonHidden(true)) { // إزالة زر العودة هنا
                Image("profileImage") // <-- استخدمي اسم الصورة بالضبط
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 4)
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
    @Binding var selectedTab: String  // استقبال الـ Binding هنا
    
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
        .padding(.bottom, 25)
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
    NavigationStack {
        HomePageView()
    }
}
