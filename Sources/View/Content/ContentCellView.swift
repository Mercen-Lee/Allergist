//
//  ContentCellView.swift
//
//
//  Created by Mercen on 2023/04/12.
//

import SwiftUI

struct ContentCellView: View {
    
    @ObservedObject var state = SelectionState()
    @State private var hasAllergy: Bool = false
    @State private var opened: Bool = false
    let food: [String]
    
    func matchedAllergen() -> [Allergy]? {
        if food.count == 3 {
            var temp = [Allergy]()
            for item in food[2].components(separatedBy: ",") {
                if let item = Int(item) {
                    temp.append(Allergy.allCases[item - 1])
                }
            }
            let data = temp.filter { state.selected.contains($0) }
            DispatchQueue.main.async {
                hasAllergy = !data.isEmpty
            }
            return data.isEmpty ? nil : data
        } else { return nil }
    }
    
    func symptomIsEmpty() -> Bool {
        if let allergen = matchedAllergen() {
            for item in allergen {
                if let symptom = state.symptom[item], !symptom.isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    @ViewBuilder func allergyCapsule(_ image: Image,
                                     _ title: String,
                                     _ foregroundColor: Color,
                                     _ backgroundColor: Color) -> some View
    {
        HStack(spacing: 4) {
            image
                .resizable()
                .scaledToFit()
                .font(Font.title.weight(.bold))
                .foregroundColor(backgroundColor)
                .frame(width: 8, height: 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(foregroundColor)
                .clipShape(Circle())
                .frame(width: 13, height: 13)
            Text(title)
                .font(.caption)
                .foregroundColor(foregroundColor)
        }
        .padding(.vertical, 2)
        .padding(.leading, 3)
        .padding(.trailing, 6)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.default) {
                opened.toggle()
            }
        }) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    if food.count > 1 {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(food[0])
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.leading, 1)
                                .padding(.horizontal, 20)
                                .lineLimit(1)
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text(food[1])
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 20)
                            }
                            .fader()
                        }
                    }
                    HStack(alignment: .bottom, spacing: 10) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                if let allergen = matchedAllergen() {
                                    ForEach(allergen, id: \.self) { data in
                                        allergyCapsule(Image(data.rawValue),
                                                       data.rawValue,
                                                       .white,
                                                       Color("SecondaryColor"))
                                    }
                                } else {
                                    allergyCapsule(Image(systemName: "checkmark"),
                                                   "No Matching Allergen",
                                                   Color(.label),
                                                   Color("Caption"))
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .fader()
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .font(Font.title.weight(.bold))
                            .frame(width: 13, height: 8)
                            .foregroundColor(hasAllergy ? .white : Color(.label))
                            .rotationEffect(.degrees(opened ? 180 : 0))
                            .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 14)
                .background(hasAllergy ? Color.accentColor : Color("Foreground"))
                if opened {
                    VStack(alignment: .leading, spacing: 0) {
                        if let allergen = matchedAllergen() {
                            ScrollView(.horizontal, showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 7) {
                                    ForEach(allergen, id: \.self) { data in
                                        if let symptom = state.symptom[data], !symptom.isEmpty {
                                            HStack(spacing: 1) {
                                                Image(data.rawValue)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 10, height: 10)
                                                Text("\(data.rawValue):")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .padding(.trailing, 3)
                                                Text(symptom)
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        HStack {
                            Spacer()
                            Link(destination: { () -> URL in
                                let mailto = "contact@mercen.net"
                                let subject = "Reporting Wrong Information from Allergist"
                                let body = "Food Info: \(food[0]) - \(food[1])\n\nMore Info: "
                                let coded = "mailto:\(mailto)?subject=\(subject)&body=\(body)"
                                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                return URL(string: coded!)!
                            }()) {
                                HStack(spacing: 5) {
                                    Text("Report")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Image(systemName: "exclamationmark.bubble.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .font(Font.title.weight(.black))
                                        .frame(width: 13, height: 13)
                                }
                            }
                            .padding(.trailing, 20)
                        }
                    }
                    .fader()
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(.label))
                    .background(Color("Fields"))
                }
            }
        }
        .foregroundColor(hasAllergy ? .white : Color(.label))
        .cornerRadius(6)
        .elevation()
    }
}
