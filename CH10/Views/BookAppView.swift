//
//  BookAppView.swift
//  CH10
//
//  Created by Michael Deal on 7/9/26.
//

import SwiftUI

struct BookAppView: View {
    let specialist: Specialist

    @State private var selectedService = "Signature"
    @State private var selectedDate = Date()
    @State private var notes = ""
    @State private var isShowingConfirmation = false

    private let primaryPurple = Color(red: 0.36, green: 0.36, blue: 0.89)
    private let pageBackground = Color(red: 0.95, green: 0.95, blue: 1.0)
    private let services = ["Signature", "Full Set", "Refresh", "Consultation"]

    init(specialist: Specialist = BeautyData.specialists[0]) {
        self.specialist = specialist
    }

    var body: some View {
        ZStack {
            pageBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    specialistSummary
                    appointmentForm
                    confirmButton
                }
                .padding(24)
            }
        }
        .navigationTitle("Book Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Appointment Requested", isPresented: $isShowingConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your appointment request with \(specialist.name) has been saved.")
        }
    }

    private var specialistSummary: some View {
        VStack(spacing: 14) {
            SpecialistAvatar(index: specialist.avatarIndex)

            VStack(spacing: 6) {
                Text(specialist.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(primaryPurple)
                    .multilineTextAlignment(.center)

                Text(specialist.specialty)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.gray)

                HStack(spacing: 16) {
                    Label(specialist.rating.formatted(.number.precision(.fractionLength(1))), systemImage: "star.fill")
                        .foregroundStyle(.orange)

                    Text(specialist.price)
                        .foregroundStyle(.black.opacity(0.85))
                }
                .font(.system(size: 15, weight: .semibold))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 21))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 7)
    }

    private var appointmentForm: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Appointment Details")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black.opacity(0.9))

            Picker("Service", selection: $selectedService) {
                ForEach(services, id: \.self) { service in
                    Text(service).tag(service)
                }
            }
            .pickerStyle(.segmented)

            DatePicker(
                "Date and Time",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .font(.system(size: 16, weight: .semibold))
            .tint(primaryPurple)

            VStack(alignment: .leading, spacing: 8) {
                Text("Notes")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.85))

                TextField("Add appointment notes", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .padding(12)
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 21))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 7)
    }

    private var confirmButton: some View {
        Button {
            isShowingConfirmation = true
        } label: {
            Text("Confirm Booking")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(primaryPurple)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        BookAppView(specialist: BeautyData.specialists[0])
    }
}
