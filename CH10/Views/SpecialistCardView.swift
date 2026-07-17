//
//  SpecialistCardView.swift
//  CH10
//
//  Created by Michael Deal on 7/13/26.
//

import SwiftUI
import UIKit

// MARK: - Specialist Card

struct SpecialistCardView: View {
    let specialist: Specialist
    var onBook: () -> Void

    @State private var isLiked = false
    @State private var isDescriptionExpanded = false
    @State private var imageScale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    private let primaryPurple = Color(red: 0.36, green: 0.36, blue: 0.89)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                specialistImage

                VStack(alignment: .leading, spacing: 5) {
                    Text(specialist.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(primaryPurple)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text(specialist.specialty)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                likeIndicator
            }

            descriptionSection

            HStack(alignment: .center, spacing: 12) {
                priceView

                Spacer(minLength: 8)

                ratingView
                bookButton
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 7)
        .contentShape(RoundedRectangle(cornerRadius: 18))
        .onTapGesture(count: 2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isLiked.toggle()
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(specialist.name), \(specialist.specialty), rated \(specialist.rating, specifier: "%.1f") stars, base price \(specialist.basePrice, specifier: "%.0f") dollars. \(specialist.description). \(isLiked ? "Liked" : "Not liked")"
        )
        .accessibilityHint(
            "Double tap the card to \(isLiked ? "unlike" : "like") \(specialist.name). Tap \(isDescriptionExpanded ? "Read Less" : "Read More") to change the description."
        )
        .accessibilityAction(named: isLiked ? "Unlike" : "Like") {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isLiked.toggle()
            }
        }
        .accessibilityAction(named: isDescriptionExpanded ? "Read Less" : "Read More") {
            withAnimation(.easeInOut(duration: 0.25)) {
                isDescriptionExpanded.toggle()
            }
        }
        .accessibilityIdentifier("specialistCard_\(specialist.accessibilityID)")
    }

    private var specialistImage: some View {
        SpecialistAvatar(
            imageName: specialist.imageName,
            scale: imageScale * gestureScale
        )
        .gesture(
            MagnificationGesture()
                .updating($gestureScale) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    imageScale = min(max(imageScale * value, 1.0), 2.0)
                }
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                imageScale = 1.0
            }
        }
        .accessibilityHidden(true)
    }

    private var likeIndicator: some View {
        Image(systemName: isLiked ? "heart.fill" : "heart")
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(isLiked ? .red : .gray.opacity(0.75))
            .scaleEffect(isLiked ? 1.12 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)
            .accessibilityHidden(true)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(specialist.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.gray)
                .lineLimit(isDescriptionExpanded ? nil : 2)
                .fixedSize(horizontal: false, vertical: true)

            Text(isDescriptionExpanded ? "Read Less" : "Read More")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(primaryPurple)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isDescriptionExpanded.toggle()
                    }
                }
        }
    }

    private var priceView: some View {
        Text("Base · $\(specialist.basePrice, specifier: "%.0f")")
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.black.opacity(0.9))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    private var ratingView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

            Text("\(specialist.rating, specifier: "%.1f")")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.black.opacity(0.9))
        }
    }

    private var bookButton: some View {
        Button {
            onBook()
        } label: {
            Text("Book")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 72, height: 38)
                .background(primaryPurple)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Book \(specialist.name)")
        .accessibilityHint("Opens the booking screen for \(specialist.name)")
        .accessibilityIdentifier("bookButton_\(specialist.accessibilityID)")
    }
}

// MARK: - Specialist Avatar

struct SpecialistAvatar: View {
    let imageName: String
    var scale: CGFloat = 1.0

    private let avatarSize: CGFloat = 72

    var body: some View {
        Group {
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.gray.opacity(0.7))
            }
        }
        .scaledToFill()
        .scaleEffect(scale)
        .frame(width: avatarSize, height: avatarSize)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.white, lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .frame(width: avatarSize, height: avatarSize)
    }
}

#Preview {
    SpecialistCardView(
        specialist: Specialist(
            name: "Sarah Williams",
            specialty: "Nail Specialist",
            description: "Experienced nail specialist offering manicures, gel treatments, custom nail art, and healthy nail care. She creates polished looks tailored to each client's style.",
            rating: 4.8,
            basePrice: 85,
            imageName: "sarah"
        )
    ) {}
    .padding()
    .background(Color(red: 0.95, green: 0.95, blue: 1.0))
}
