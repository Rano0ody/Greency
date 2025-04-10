//
//  PlasticPageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//
//
//  PlasticPageView.swift
//  Greency
//
//  Created by Maha Salem Alghmadi on 12/10/1446 AH.
//

import SwiftUI

struct PlasticPageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // صورة العنوان
                ZStack(alignment: .bottomLeading) {
                    Image("plasticf")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 182)
                        .clipped()
                        .padding(.top, 1)

                    Text("Plastic")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("MainBeige"))
                        .padding(.leading, 39)
                        .padding(.bottom, 24)
                }

                // العنوان الثابت
                Text("The types of plastics that are less recyclable")
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
                        ForEach(PlasticTypes, id: \.title) { type in
                            VStack(alignment: .center, spacing: 6)
 {
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

struct PlasticPageView_Previews: PreviewProvider {
    static var previews: some View {
        PlasticPageView()
    }
}

struct PlasticType: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

let PlasticTypes: [PlasticType] = [
    PlasticType(title: "Polyvinyl Chloride (PVC - ♻︎)", description: "Difficult to recycle due to the presence of harmful chemicals."),
    PlasticType(title: "Low-Density Polyethylene (LDPE - ♻︎)", description: "Recycled, but with difficulty."),
    PlasticType(title: "Polypropylene (PP - ♻︎)", description: "Recycled, but not on a large scale."),
    PlasticType(title: "Polystyrene (PS - ♻︎)", description: "Rarely recycled due to its brittleness and processing difficulty."),
    PlasticType(title: "Other types (Other - ♻︎)", description: "A plastic mixture that is generally non-recyclable.")
]


#Preview {
    PlasticPageView ()
}


