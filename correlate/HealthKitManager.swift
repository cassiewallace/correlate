//
//  HealthKitManager.swift
//  correlate
//
//  Created by Cassie Wallace on 3/4/25.
//

import HealthKit

class HealthKitManager: ObservableObject {
  static let shared = HealthKitManager()

  var healthStore = HKHealthStore()
}
