//
//  SpecialistView.swift
//  CH10
//
//  Created by Michael Deal on 7/9/26.
//

import SwiftUI
import UIKit

struct SpecialistView: View {
    @State private var searchText = ""
    @State private var selectedCategoryID: UUID?
    @State private var selectedSpecialist: Specialist?

    private let primaryPurple = Color(red: 0.36, green: 0.36, blue: 0.89)
    private let pageBackground = Color(red: 0.95, green: 0.95, blue: 1.0)

    private let categories = [
        CategoryItem(icon: "eye.slash", title: "Lashes"),
        CategoryItem(icon: "xmark.circle", title: "Nails"),
        CategoryItem(icon: "scissors", title: "Hair")
    ]

    private let specialists = [
        Specialist(
            name: "Amelia Johnson",
            specialty: "Lash Artist",
            rating: 4.9,
            basePrice: 120,
            imageName: "amelia"
        ),
        Specialist(
            name: "Sarah Williams",
            specialty: "Nail Specialist",
            rating: 4.8,
            basePrice: 85,
            imageName: "sarah"
        ),
        Specialist(
            name: "Elena Rodriguez",
            specialty: "Hair Stylist",
            rating: 5.0,
            basePrice: 150,
            imageName: "elena"
        )
    ]

    private var selectedCategory: CategoryItem? {
        categories.first { $0.id == selectedCategoryID }
    }

    private var filteredSpecialists: [Specialist] {
        specialists.filter { specialist in
            let matchesCategory = selectedCategory == nil || specialist.matches(categoryTitle: selectedCategory?.title ?? "")
            let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmedSearch.isEmpty else {
                return matchesCategory
            }

            let matchesSearch = specialist.name.localizedCaseInsensitiveContains(trimmedSearch)
                || specialist.specialty.localizedCaseInsensitiveContains(trimmedSearch)

            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                pageBackground
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerView

                        VStack(spacing: 28) {
                            categoriesSection
                            topSpecialistSection
                        }
                        .padding(.top, 28)
                        .padding(.bottom, 28)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .safeAreaPadding(.bottom, 12)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedSpecialist) { specialist in
                BookAppView(specialist: specialist)
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 30) {
            Spacer(minLength: 0)

            Text("Find Your Beauty\nSpecialist!")
                .font(.system(size: 29, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            HStack(spacing: 14) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(primaryPurple)

                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("Search specialist...")
                        .foregroundStyle(.gray.opacity(0.7))
                )
                .font(.system(size: 18))
                .foregroundStyle(.primary)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal, 28)
            .padding(.bottom, 46)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 372)
        .padding(.top, 24)
        .background(
            RoundedCorner(radius: 24, corners: [.bottomLeft, .bottomRight])
                .fill(primaryPurple)
        )
    }

    private var categoriesSection: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Categories")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(.black.opacity(0.9))

                Spacer()

                NavigationLink {
                    CategoryView(selectedCategory: selectedCategory)
                } label: {
                    Text("See all")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(primaryPurple)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 28)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(categories) { category in
                        CategoryCardView(
                            icon: category.icon,
                            title: category.title,
                            isSelected: selectedCategoryID == category.id
                        ) {
                            selectedCategoryID = selectedCategoryID == category.id ? nil : category.id
                        }
                        .frame(width: 96)
                    }
                }
                .padding(.horizontal, 28)
            }
        }
    }

    private var topSpecialistSection: some View {
        VStack(spacing: 18) {
            sectionHeader(title: "Top Specialist") {
                selectedCategoryID = nil
                searchText = ""
            }

            if filteredSpecialists.isEmpty {
                Text("No specialists found")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 34)
                    .padding(.horizontal, 28)
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(filteredSpecialists) { specialist in
                        SpecialistCardView(specialist: specialist) {
                            selectedSpecialist = specialist
                        }
                    }
                }
                .padding(.horizontal, 28)
            }
        }
    }

    private func sectionHeader(title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.black.opacity(0.9))

            Spacer()

            Button(action: action) {
                Text("See all")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(primaryPurple)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SpecialistView()
}
