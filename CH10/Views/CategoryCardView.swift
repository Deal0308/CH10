//
//  CategoryCardView.swift
//  CH10
//
//  Created by Michael Deal on 7/13/26.
//

import SwiftUI

// MARK: - Category Card

struct CategoryCardView: View {
    let icon: String
    let title: String

    private let primaryPurple = Color(
        red: 0.36,
        green: 0.36,
        blue: 0.89
    )

    var body: some View {
        VStack(spacing: 13) {
            ZStack {
                Circle()
                    .fill(primaryPurple.opacity(0.1))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(primaryPurple)
            }

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black.opacity(0.72))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 124)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 17)
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 14,
            x: 0,
            y: 7
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}

#Preview {
    HStack(spacing: 14) {
        CategoryCardView(
            icon: "eye",
            title: "Lashes"
        )

        CategoryCardView(
            icon: "wind",
            title: "Hair"
        )

        CategoryCardView(
            icon: "hand.raised",
            title: "Nails"
        )
    }
    .padding()
    .background(
        Color(
            red: 0.95,
            green: 0.95,
            blue: 1.0
        )
    )
}