//
//  SelectionCellView.swift
//  
//
//  Created by Mercen on 2023/04/13.
//

import SwiftUI

struct SelectionCellView: View {
    
    @EnvironmentObject var state: SelectionState
    let allergy: Allergy
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.default) {
                    if state.selected.contains(allergy) {
                        if let index = state.selected.firstIndex(of: allergy) {
                            state.selected.remove(at: index)
                        }
                    } else {
                        state.selected.append(allergy)
                    }
                }
            }) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(allergy.rawValue)
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.leading, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                Text(allergy.description)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 20)
                        }
                        .fader()
                    }
                    .padding(.vertical, 14)
                    ZStack(alignment: .bottomTrailing) {
                        Image(allergy.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity)
                        if state.selected.contains(allergy) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .font(Font.title.weight(.bold))
                                .padding(5)
                        }
                    }
                        .foregroundColor(.white)
                        .background({ () -> Color in
                            if state.selected.contains(allergy) {
                                return .accentColor
                            } else {
                                return Color("Cards")
                            }
                        }())
                }
                .frame(maxHeight: .infinity)
            }
            .accessibilityLabel(Text("\(state.selected.contains(allergy) ? "Unselect" : "Select") \(allergy.rawValue)"))
            if state.selected.contains(allergy) {
                TextField("Enter Symptom (Optional)",
                          text: Binding(get: { state.symptom[allergy]! },
                                        set: { state.symptom[allergy] = $0 }))
                .submitLabel(.done)
                .font(.caption)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(Color("Fields"))
                .accessibilityLabel(Text("Enter Symptom for \(allergy.rawValue)"))
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color("Foreground"))
        .cornerRadius(6)
        .elevation()
    }
}
