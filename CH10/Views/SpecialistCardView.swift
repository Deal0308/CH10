//
//  SpecialistCardView.swift
//  CH10
//
//  Created by Michael Deal on 7/13/26.
//

import SwiftUI

// MARK: - Specialist Card

struct SpecialistCardView: View {
    let specialist: Specialist
    var onBook: () -> Void

    private let primaryPurple = Color(red: 0.36, green: 0.36, blue: 0.89)

    var body: some View {
        HStack(spacing: 14) {
            SpecialistAvatar(imageName: specialist.imageName)

            VStack(alignment: .leading, spacing: 5) {
                Text(specialist.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(primaryPurple)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(specialist.specialty)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.gray)
                    .lineLimit(1)

                Spacer(minLength: 2)

                Text(specialist.formattedBasePrice)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.9))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 26) {
                HStack(spacing: 4) {
                    Image(systemName: "star")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.orange)

                    Text(specialist.rating.formatted(.number.precision(.fractionLength(1))))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.9))
                }

                Button(action: onBook) {
                    Text("Book")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 72, height: 38)
                        .background(primaryPurple)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 110)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 21))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 7)
        .contentShape(RoundedRectangle(cornerRadius: 21))
        .onTapGesture(perform: onBook)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Specialist Avatar

struct SpecialistAvatar: View {
    let imageName: String

    private let avatarSize: CGFloat = 72

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 2)
            }
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SpecialistCardView(
        specialist: Specialist(
            name: "Sarah Smith",
            specialty: "Hair",
            rating: 4.9,
            basePrice: 120,
            imageName: "specialist1"
        )
    ) {}
    .padding()
    .background(Color(red: 0.95, green: 0.95, blue: 1.0))
}
