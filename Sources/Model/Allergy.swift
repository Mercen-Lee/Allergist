//
//  Allergy.swift
//
//
//  Created by Mercen on 2023/04/12.
//

import Foundation

enum Allergy: String, CaseIterable {
    case gluten = "Gluten"
    case crustaceans = "Crustaceans"
    case eggs = "Eggs"
    case fish = "Fish"
    case peanuts = "Peanuts"
    case soya = "Soya"
    case milk = "Milk"
    case treenuts = "Treenuts"
    case celery = "Celery"
    case mustard = "Mustard"
    case sesame = "Sesame"
    case sulphites = "Sulphites"
    case lupin = "Lupin"
    case molluscs = "Molluscs"
    
    var description: String {
        switch self {
        case .gluten:
            return "Wheat, Bran, Durun, Einkorn contains Gluten."
        case .crustaceans:
            return "Crab, Shrimp, Lobster, Ecrevisse are Crustaceans."
        case .eggs:
            return "Foods containing Eggs."
        case .fish:
            return "All fishes contains Anchovy, Bass, Cod, Tuna."
        case .peanuts:
            return "Foods contaning Peanuts."
        case .soya:
            return "Soybean, Tofu, Miso, Natto contains Soya."
        case .milk:
            return "Cheese, Butter, Yogurt contains Milk."
        case .treenuts:
            return "Almond, Chestnut, Walnut, Macadamia are Treenuts."
        case .celery:
            return "Foods containing Celery."
        case .mustard:
            return "All mustards including Dijon."
        case .sesame:
            return "All sesame including Til."
        case .sulphites:
            return "Foods containing Sulphur Dioxide."
        case .lupin:
            return "Foods containing Lupin."
        case .molluscs:
            return "Squid, Oyster, Octopus, Snail are Molluscs."
        }
    }
}
