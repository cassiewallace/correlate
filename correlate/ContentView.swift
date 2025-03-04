//
//  ContentView.swift
//  correlate
//
//  Created by Cassie Wallace on 3/4/25.
//

import HealthKitUI
import SwiftUI

struct ContentView: View {
    @State var authenticated = false
    @State var trigger = false
    let healthStore = HKHealthStore()
    
    let allTypes: Set = [
        HKQuantityType.stateOfMindType()
    ]

    var body: some View {
        Button("Access health data") {
            if HKHealthStore.isHealthDataAvailable() {
                trigger.toggle()
            }
        }
        .disabled(!authenticated)
        .healthDataAccessRequest(store: healthStore,
                                 shareTypes: allTypes,
                                 readTypes: allTypes,
                                 trigger: trigger) { result in
            switch result {
            case .success(_):
                authenticated = true
            case .failure(let error):
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
