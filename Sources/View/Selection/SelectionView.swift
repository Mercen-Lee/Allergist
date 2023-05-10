//
//  SelectionView.swift
//
//
//  Created by Mercen on 2023/04/13.
//

import SwiftUI

struct SelectionView: View {
    
    @EnvironmentObject var rootState: ContentState
    @StateObject var state = SelectionState()
    
    func close() {
        if !state.selected.isEmpty {
            rootState.onboarded = true
            state.save {
                withAnimation(.spring(dampingFraction: 0.75, blendDuration: 0.5)) {
                    rootState.settings = false
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { outsideProxy in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 1) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Allergist Settings")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Select your Allergen")
                            }
                            .scaleEffect(state.topBarScale(), anchor: .bottomLeading)
                            Spacer()
                            if !state.selected.isEmpty {
                                Button(action: close) {
                                    VStack(spacing: 3) {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .font(Font.title.weight(.semibold))
                                            .foregroundColor(.white)
                                            .frame(width: 16, height: 16)
                                            .padding(.horizontal, 23)
                                            .padding(.vertical, 7)
                                            .background(Color.accentColor)
                                            .cornerRadius(6)
                                        Text("Done")
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                    }
                                }
                                .offset(y: 4)
                                .scaleEffect(state.topBarScale(), anchor: .bottomTrailing)
                            }
                        }
                        .padding(.top, 35)
                        .padding(.bottom)
                        VStack(spacing: 0) {
                            GeometryReader { insideProxy in
                                EmptyView()
                                    .onChange(of: insideProxy.frame(in: .global).minY) { newValue in
                                        DispatchQueue.main.async {
                                            let tempProxy = -(outsideProxy.frame(in: .global).minY - newValue) / 80
                                            state.proxy = tempProxy <= 0 ? 0 : tempProxy
                                        }
                                    }
                            }
                            VStack(spacing: 11) {
                                ForEach(Allergy.allCases, id: \.self) { allergy in
                                    SelectionCellView(allergy: allergy)
                                        .environmentObject(state)
                                }
                                .foregroundColor(Color(.label))
                            }
                            .dismissButton()
                        }
                    }
                    .padding([.horizontal, .bottom], 24)
                    .frame(maxWidth: .infinity)
                }
                .background(Color("Background").ignoresSafeArea())
                Color("Background")
                    .frame(maxWidth: .infinity)
                    .frame(height: outsideProxy.safeAreaInsets.top + 40)
                    .edgesIgnoringSafeArea(.top)
                ZStack(alignment: .trailing) {
                    Text("Allergist Settings")
                        .font(.headline)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                    if !state.selected.isEmpty {
                        Button(action: close) {
                            HStack(spacing: 5) {
                                Text("Done")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.white, Color.accentColor)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .padding(.trailing, 26)
                        .smoothAnimation(.trailing)
                    }
                }
                .padding(.top, 100)
                .background(Color("Foreground"))
                .elevation()
                .opacity({ () -> CGFloat in
                    if state.proxy <= 0.63 {
                        return 1
                    } else if state.proxy >= 0.73 {
                        return 0
                    } else {
                        return (0.73 - state.proxy) * 10
                    }
                }())
                .offset(y: -100)
            }
        }
    }
}
