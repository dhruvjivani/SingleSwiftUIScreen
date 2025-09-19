//
//  TripView.swift
//  9044406_Assignment_1
//
//  Created by Dhruv Rasikbhai Jivani on 9/18/25.
//

import SwiftUI

struct TripView: View {
    @State private var tripTitle = ""
    @State private var destination = ""
    @State private var tripType = "Leisure"
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var notes = ""
    @State private var travelers = 1
    @State private var showAlert = false
    @State private var selectedSegment = "Details"

    let tripTypes = ["Leisure", "Business"]

    var isTitleValid: Bool { tripTitle.trimmingCharacters(in: .whitespaces).count >= 2 }
    var isDestinationValid: Bool { destination.trimmingCharacters(in: .whitespaces).count >= 2 }
    var isDateValid: Bool { startDate <= endDate }
    var isNotesValid: Bool { notes.count <= 250 }
    var isTravelersValid: Bool { travelers >= 1 && travelers <= 10 }
    var isFormValid: Bool { isTitleValid && isDestinationValid && isDateValid && isNotesValid && isTravelersValid }

    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }

    var tripDuration: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1
    }

    var truncatedNotes: String {
        if notes.count > 150 {
            let index = notes.index(notes.startIndex, offsetBy: 150)
            return "\(notes[..<index])..."
        }
        return notes
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trip Planner")
                        .modifier(TitleStyle())
                    Text("Create and plan your next great adventure.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Segmented Picker
                Picker("View Mode", selection: $selectedSegment) {
                    Text("Details").tag("Details")
                    Text("Summary").tag("Summary")
                }
                .pickerStyle(.segmented)

                // Form Content based on selected segment
                if selectedSegment == "Details" {
                    detailsView
                } else {
                    summaryView
                }

                // Buttons
                HStack {
                    Button("Reset") {
                        tripTitle = ""
                        destination = ""
                        tripType = "Leisure"
                        startDate = Date()
                        endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                        notes = ""
                        travelers = 1
                    }

                    Spacer()

                    Button("Save") {
                        showAlert = true
                    }
                    .disabled(!isFormValid)
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .alert("Trip Saved!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("""
            Trip: \(tripTitle)
            Destination: \(destination)
            Type: \(tripType)
            Dates: \(formattedDateRange)
            Duration: \(tripDuration) day(s)
            Travelers: \(travelers)
            Notes: \(truncatedNotes)
            """)
        }
    }

    // Extracted views for clarity
    var detailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Trip Title", text: $tripTitle)
                .textFieldStyle(.roundedBorder)
            if !isTitleValid {
                Text("Title must be at least 2 characters.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            TextField("Destination", text: $destination)
                .textFieldStyle(.roundedBorder)
            if !isDestinationValid {
                Text("Destination must be at least 2 characters.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Picker("Trip Type", selection: $tripType) {
                ForEach(tripTypes, id: \.self) { type in
                    Text(type)
                }
            }
            .pickerStyle(.menu)

            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            if !isDateValid {
                Text("Start date must be before or equal to end date.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            HStack {
                Text("Travelers: \(travelers)")
                Spacer()
                Stepper("", value: $travelers, in: 1...10)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Notes")
                    .font(.headline)
                TextEditor(text: $notes)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .overlay(
                        Text(notes.isEmpty ? "Add notes about your trip..." : "")
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.all, 8)
                            .allowsHitTesting(false),
                        alignment: .topLeading
                    )

                HStack {
                    Spacer()
                    Text("\(notes.count)/250")
                        .foregroundColor(notes.count > 250 ? .red : .secondary)
                        .font(.caption)
                }
                if !isNotesValid {
                    Text("Notes cannot exceed 250 characters.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .modifier(CardStyle())
    }

    var summaryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trip: **\(tripTitle)**")
            Text("Destination: **\(destination)**")
            Text("Type: **\(tripType)**")
            Text("Dates: **\(formattedDateRange)**")
            Text("Duration: **\(tripDuration) day(s)**")
            Text("Travelers: **\(travelers)**")
            VStack(alignment: .leading) {
                Text("Notes:")
                Text(truncatedNotes)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(CardStyle())
    }
}
