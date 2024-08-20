import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    let readTypes: Set<HKSampleType> = [
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!
    ]
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }
    
    func fetchSleepAnalysis(completion: @escaping ([HKCategorySample]?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil)
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 7, sortDescriptors: [sortDescriptor]) { (query, result, error) in
            if let result = result as? [HKCategorySample] {
                completion(result)
            } else {
                completion(nil)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchHeartRateData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil)
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 7, sortDescriptors: [sortDescriptor]) { (query, result, error) in
            if let result = result as? [HKQuantitySample] {
                completion(result)
            } else {
                completion(nil)
            }
        }
        
        healthStore.execute(query)
    }
}
