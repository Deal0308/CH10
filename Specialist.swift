//
//  Specialist.swift
//  CH10
//
//  Created by Michael Deal on 7/13/26.
//

import Foundation

// MARK: - Specialist Model

final class Specialist: Identifiable, Hashable {
    let id: UUID
    let name: String
    let specialty: String
    let rating: Double
    let basePrice: Double
    let imageName: String

    init(
        id: UUID = UUID(),
        name: String,
        specialty: String,
        rating: Double,
        basePrice: Double,
        imageName: String
    ) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.rating = rating
        self.basePrice = basePrice
        self.imageName = imageName
    }

    static func == (lhs: Specialist, rhs: Specialist) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var formattedBasePrice: String {
        "Base · $\(basePrice.formatted(.number.precision(.fractionLength(0))))"
    }

    func matches(categoryTitle: String) -> Bool {
        switch categoryTitle {
        case "Lashes":
            specialty.localizedCaseInsensitiveContains("lash")
        case "Nails":
            specialty.localizedCaseInsensitiveContains("nail")
        case "Hair":
            specialty.localizedCaseInsensitiveContains("hair")
        default:
            specialty.localizedCaseInsensitiveContains(categoryTitle)
        }
    }
}
