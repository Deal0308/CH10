//
//  CategoryView.swift
//  CH10
//
//  Created by Michael Deal on 7/9/26.
//

import SwiftUI

struct CategoryView: View {
    @State private var selectedCategoryID: UUID?
    @State private var selectedSpecialist: Specialist?

    private let categories: [CategoryItem]
    private let specialists: [Specialist]
    private let primaryPurple = Color(red: 0.36, green: 0.36, blue: 0.89)
    private let pageBackground = Color(red: 0.95, green: 0.95, blue: 1.0)

    init(
        selectedCategory: CategoryItem? = nil,
        categories: [CategoryItem] = [
            CategoryItem(icon: "eye.slash", title: "Lashes"),
            CategoryItem(icon: "xmark.circle", title: "Nails"),
            CategoryItem(icon: "scissors", title: "Hair")
        ],
        specialists: [Specialist] = [
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
    ) {
        _selectedCategoryID = State(initialValue: selectedCategory?.id)
        self.categories = categories
        self.specialists = specialists
    }

    private var selectedCategory: CategoryItem? {
        categories.first { $0.id == selectedCategoryID }
    }

    private var filteredSpecialists: [Specialist] {
        guard let selectedCategory else {
            return specialists
        }

        return specialists.filter { $0.matches(categoryTitle: selectedCategory.title) }
    }

    var body: some View {
        ZStack {
            pageBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    categoryGrid
                    specialistResults
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle(selectedCategory?.title ?? "Categories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedSpecialist) { specialist in
            BookAppView(specialist: specialist)
        }
    }

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Categories")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.black.opacity(0.9))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 14)], spacing: 14) {
                ForEach(categories) { category in
                    CategoryCardView(
                        icon: category.icon,
                        title: category.title,
                        isSelected: selectedCategoryID == category.id
                    ) {
                        selectedCategoryID = selectedCategoryID == category.id ? nil : category.id
                    }
                }
            }
        }
    }

    private var specialistResults: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(resultTitle)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(.black.opacity(0.9))

                Spacer()

                if selectedCategoryID != nil {
                    Button("Clear") {
                        selectedCategoryID = nil
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(primaryPurple)
                    .buttonStyle(.plain)
                }
            }

            if filteredSpecialists.isEmpty {
                Text("No specialists found")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 34)
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(filteredSpecialists) { specialist in
                        SpecialistCardView(specialist: specialist) {
                            selectedSpecialist = specialist
                        }
                    }
                }
            }
        }
    }

    private var resultTitle: String {
        if let selectedCategory {
            return "\(selectedCategory.title) Specialists"
        }

        return "All Specialists"
    }
}

#Preview {
    NavigationStack {
        CategoryView(
            selectedCategory: CategoryItem(icon: "eye.slash", title: "Lashes")
        )
    }
}
