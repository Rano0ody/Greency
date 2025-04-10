//
//  GlassPageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//
//
//  GlassPageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//

import SwiftUI

struct GlassPageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // صورة العنوان
                ZStack(alignment: .bottomLeading) {
                    Image("Glassf")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 182)
                        .clipped()
                        .padding(.top, 1)

                    Text("Glass")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("MainBeige"))
                        .padding(.leading, 39)
                        .padding(.bottom, 24)
                }

                // العنوان الثابت
                Text("Types of Glass Less Recyclable")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(Color.white.cornerRadius(10))
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                Spacer().frame(height: 30)

                // الكروت
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(glassTypes, id: \.title) { type in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(type.title)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)

                                Text(type.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(width: 382)
                            .background(Color("MainGreen"))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        }

                        Spacer(minLength: 20)
                    }
                }
            }
            // no need for .navigationBarHidden(true)
        }
    }
}

struct GlassPageView_Previews: PreviewProvider {
    static var previews: some View {
        GlassPageView()
    }
}

struct GlassType {
    let title: String
    let description: String
}

let glassTypes: [GlassType] = [
    GlassType(title: "Damaged Glass", description: "Difficult to recycle due to cracks or breakage, which makes it hard to process in factories and may contain small pieces that are difficult to separate."),
    GlassType(title: "Contaminated Glass", description: "Difficult to recycle if it contains contaminants such as food residue or chemicals, which can cause contamination and make the recycling process more complicated."),
    GlassType(title: "Mixed Glass with Other Materials", description: "Difficult to recycle if it contains contaminants such as food residue or chemicals, which can cause contamination and make the recycling process more complicated."),
    GlassType(title: "Tempered Glass", description: "Difficult to recycle because it has been heat-treated to become stronger, making it brittle and hard to break into small pieces that can be processed easily."),
    GlassType(title: "Decorative or Coated Glass", description: "Difficult to recycle if it has layers or decorative materials or coatings that may affect its quality during recycling.")
]


#Preview {
    GlassPageView ()
}

