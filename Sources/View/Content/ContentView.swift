//
//  ContentView.swift
//
//
//  Created by Mercen on 2023/04/10.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var state = ContentState()
    @FocusState var focusState: Bool
    
    var body: some View {
        Group {
            if state.settings {
                SelectionView()
                    .environmentObject(state)
                    .smoothAnimation(.top)
            } else {
                GeometryReader { outsideProxy in
                    ZStack(alignment: .top) {
                        if state.searchState {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 1) {
                                    GeometryReader { insideProxy in
                                        EmptyView()
                                            .onChange(of: insideProxy.frame(in: .global).minY) { newValue in
                                                DispatchQueue.main.async {
                                                    let tempProxy = -(outsideProxy.frame(in: .global).minY - newValue) / 80
                                                    state.proxy = tempProxy <= 0 ? 0 : tempProxy >= 1 ? 1 : tempProxy
                                                    state.overProxy = tempProxy - 1 <= 0 ? 0 : tempProxy - 1
                                                }
                                            }
                                    }
                                    if state.viewData.isEmpty {
                                        Text("No Result Found")
                                            .padding(.top, UIScreen.main.bounds.size.height / 2 - 130)
                                            .smoothAnimation(.bottom)
                                    } else {
                                        LazyVStack(spacing: 11) {
                                            ForEach(state.viewData, id: \.self) { data in
                                                ContentCellView(food: data)
                                            }
                                        }
                                        .smoothAnimation(.bottom)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, outsideProxy.safeAreaInsets.top + 80)
                                .padding(.bottom, 24)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .smoothAnimation(.bottom)
                        }
                        ZStack(alignment: .bottomTrailing) {
                            VStack(alignment: .trailing, spacing: 20) {
                                if !state.searchState {
                                    Image("Logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200)
                                        .smoothAnimation(.top)
                                        .frame(maxWidth: .infinity)
                                        .scaleEffect(state.loaded && state.onboarded ? 1 : 1.3)
                                        .padding(.top, state.loaded ? 0 : outsideProxy.safeAreaInsets.top)
                                }
                                if state.loaded && state.onboarded {
                                    HStack {
                                        TextField("Search for Food", text: $state.searchText)
                                            .submitLabel(.search)
                                            .focused($focusState)
                                            .onSubmit(state.search)
                                            .dismissButton()
                                            .onChange(of: focusState) { newValue in
                                                withAnimation(.default) {
                                                    state.searchFieldState = !(!newValue && state.searchState)
                                                }
                                            }
                                        Spacer()
                                        Button(action: state.search) {
                                            Image(systemName: state.searchFieldState ? "magnifyingglass" : "xmark")
                                                .rotationEffect(.degrees(state.searchFieldState ? 0 : 270))
                                        }
                                    }
                                    .foregroundColor(Color(.label))
                                    .font(.body)
                                    .padding(.vertical, state.searchState ? 11 : 20)
                                    .padding(.horizontal, 20)
                                    .padding(.top, state.searchState ? outsideProxy.safeAreaInsets.top * (1 - state.proxy) : 0)
                                    .background(Color("Foreground"))
                                    .cornerRadius(state.searchState ? 20 * state.proxy : 10)
                                    .padding(.horizontal, state.searchState ? 24 * state.proxy : 24)
                                    .padding(.top, state.searchState
                                             ? (outsideProxy.safeAreaInsets.top * state.proxy + 24 * state.proxy) + 20 * state.overProxy
                                             : 0)
                                    .elevation()
                                }
                            }
                            .frame(maxHeight: state.searchState ? nil : .infinity)
                            if !state.searchState && state.loaded {
                                Button(action: {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                    to: nil, from: nil, for: nil)
                                    withAnimation(.spring(dampingFraction: 0.75, blendDuration: 0.5)) {
                                        state.settings = true
                                    }
                                }) {
                                    if state.onboarded {
                                        HStack(spacing: 5) {
                                            Text("Settings")
                                                .font(.footnote)
                                                .foregroundColor(Color(.label))
                                                .fontWeight(.medium)
                                            Image(systemName: "gearshape.fill")
                                                .resizable()
                                                .foregroundColor(.accentColor)
                                                .frame(width: 15, height: 15)
                                        }
                                    } else {
                                        Text("Get Started")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 13)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.accentColor)
                                            .cornerRadius(6)
                                            .elevation()
                                    }
                                }
                                .accessibilityLabel(Text("Settings"))
                                .padding([.bottom, .trailing], state.onboarded ? 24 : 0)
                                .padding([.bottom, .horizontal], state.onboarded ? 0 : 24)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            }
        }
        .background((state.loaded ? Color("Background") : Color(.systemBackground)).ignoresSafeArea())
        .onAppear(perform: state.load)
    }
}
