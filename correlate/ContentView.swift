//
//  ContentView.swift
//  correlate
//
//  Created by Cassie Wallace on 3/4/25.
//

import HealthKit
import HealthKitUI
import SwiftUI

struct ContentView: View {
    enum StateOfMind: Int {
        case veryUnpleasant = 1
        case unpleasant = 2
        case neutral = 3
        case pleasant = 4
        case veryPleasant = 5

        var description: String {
            switch self {
            case .veryUnpleasant: return "Very Unpleasant 😢"
            case .unpleasant: return "Unpleasant 😟"
            case .neutral: return "Neutral 😐"
            case .pleasant: return "Pleasant 🙂"
            case .veryPleasant: return "Very Pleasant 😊"
            }
        }
    }
    
    @State var authenticated = false
    @State var trigger = false
    @StateObject var healthKitManager = HealthKitManager.shared
    
    let readTypes: Set = [
        HKQuantityType.stateOfMindType()
    ]

    var body: some View {
        List(healthKitManager.moodEntries) { entry in
            HStack {
                Text(moodDescription(for: entry.moodValue))
                    .font(.headline)
                Spacer()
                Text(entry.date, style: .date)
                    .foregroundColor(.gray)
            }
            
            Button("Access health data") {
                if HKHealthStore.isHealthDataAvailable() {
                    trigger.toggle()
                }
            }
            .disabled(authenticated)
        }
        .navigationTitle("Mental Wellbeing")
        .onAppear {
            healthKitManager.readMentalWellbeing()
        }
        .healthDataAccessRequest(store: healthKitManager.healthStore,
                                 shareTypes: [],
                                 readTypes: readTypes,
                                 trigger: trigger) { result in
            switch result {
            case .success(_):
                authenticated = true
            case .failure(let error):
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
    
    private func moodDescription(for value: Int) -> String {
        return StateOfMind(rawValue: value)?.description ?? "Unknown"
    }
}
