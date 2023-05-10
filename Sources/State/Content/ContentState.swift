//
//  ContentState.swift
//
//
//  Created by Mercen on 2023/04/12.
//

import SwiftUI

class ContentState: ObservableObject {
    @AppStorage("onboarded") var onboarded: Bool = false
    @Published var loaded: Bool = false
    @Published var allergyData: [[String]] = [[]]
    @Published var viewData: [[String]] = [[]]
    @Published var searchText: String = ""
    @Published var searchState: Bool = false
    @Published var searchFieldState: Bool = true
    @Published var settings: Bool = false
    @Published var proxy: CGFloat = 1.0
    @Published var overProxy: CGFloat = 0.0
    
    func load() {
        DispatchQueue.main.async {
            let data = try! Data(contentsOf: Bundle.main.url(forResource: "Data", withExtension: "plist")!)
            let plist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            self.allergyData = plist as! [[String]]
            withAnimation(.spring(dampingFraction: 0.75, blendDuration: 0.5)) {
                self.loaded = true
            }
        }
    }

    func search() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
        if searchFieldState {
            if !self.searchText.isEmpty {
                withAnimation(.spring(dampingFraction: 0.75, blendDuration: 0.5)) {
                    self.searchState = true
                    self.searchFieldState = false
                    self.viewData = self.allergyData.filter {
                        $0[1].localizedCaseInsensitiveContains(self.searchText)
                    }
                }
            }
        } else {
            withAnimation(.spring(dampingFraction: 0.75, blendDuration: 0.5)) {
                searchText = ""
                searchState = false
                searchFieldState = true
                viewData = [[]]
            }
        }
    }
}
