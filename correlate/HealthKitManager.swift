//
//  HealthKitManager.swift
//  correlate
//
//  Created by Cassie Wallace on 3/4/25.
//

import HealthKit

class HealthKitManager: ObservableObject {
    // MARK: - Internal Properties
    
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    @Published var moodEntries: [MoodEntry] = []
    
    struct MoodEntry: Identifiable {
        let id = UUID()
        let moodValue: Int
        let date: Date
    }
    
    func readMentalWellbeing() {
        let stateOfMindType = HKQuantityType.stateOfMindType()

        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: stateOfMindType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    print("Error fetching mental wellbeing data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.moodEntries = samples.map { sample in
                    MoodEntry(moodValue: sample.value, date: sample.startDate)
                }
            }
        }

        healthStore.execute(query)
    }
}
