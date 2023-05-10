//
//  SelectionState.swift
//
//
//  Created by Mercen on 2023/04/13.
//

import SwiftUI

class SelectionState: ObservableObject {
    @Published var selected: [Allergy] = {
        var temp = [Allergy]()
        if let array = UserDefaults.standard.array(forKey: "allergens") as? [String] {
            for item in array {
                temp.append(Allergy(rawValue: item)!)
            }
        }
        return temp
    }()
    @Published var proxy: CGFloat = 1.3375
    @Published var symptom: [Allergy: String] = {
        var temp = [Allergy: String]()
        for type in Allergy.allCases {
            temp[type] = UserDefaults.standard.string(forKey: type.rawValue) ?? ""
        }
        return temp
    }()
    
    func topBarScale() -> CGFloat {
        if proxy <= 1.34 {
            return 1
        } else {
            return 0.965 + (proxy - 0.33) / 30
        }
    }
    
    func save(action: @escaping () -> Void) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
        var temp = [String]()
        for item in selected {
            temp.append(item.rawValue)
        }
        UserDefaults.standard.set(temp, forKey: "allergens")
        for type in Allergy.allCases {
            UserDefaults.standard.set(symptom[type], forKey: type.rawValue)
        }
        action()
    }
}
