//
//  PaperPageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//

//
//  PaperPageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//
import SwiftUI

struct PaperPageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // صورة العنوان
                ZStack(alignment: .bottomLeading) {
                    Image("paperf")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 182)
                        .clipped()
                        .padding(.top, 1)

                    Text("Paper")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("MainBeige"))
                        .padding(.leading, 39)
                        .padding(.bottom, 24)
                }

                // العنوان الثابت
                Text("Types of Paper Less Recyclable")
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
                        ForEach(PaperTypes, id: \.title) { type in
                            VStack(alignment: .center, spacing: 6) {
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
            
        }
    }
}
struct PaperType: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

let PaperTypes: [PaperType] = [
    PaperType(
        title: "Contaminated Paper",
        description: "Difficult to recycle due to contaminants such as grease, chemicals, or food."
    ),
    PaperType(
        title: "Coated or Glossy Paper",
        description: "Difficult to recycle due to the coating layers that contain non-biodegradable materials."
    ),
    PaperType(
        title: "Wet Cardboard",
        description: "Difficult to recycle due to exposure to moisture or water, which makes it brittle."
    ),
    PaperType(
        title: "Chemically Treated",
        description: "Difficult to recycle due to the chemical treatment that may interfere with the recycling process."
    ),
    PaperType(
        title: "Colored Paper",
        description: "Difficult to recycle due to the artificial colors that may affect the quality of recycling."
    )
]

#Preview {
   PaperPageView ()
}

