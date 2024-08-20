// 

import SwiftUI

struct HeadacheInputView: View {
    @State private var date = Date()
    @State private var duration: Double = 60 // duration in minutes
    @State private var intensity: Double = 5
    @State private var selectedTriggers = [String]()
    @State private var selectedSymptoms = [String]()
    
    @State private var showInsights = false
    @State private var likelihood: Double = 0.0
    
    let triggers = ["Stress", "Lack of Sleep", "Dehydration", "Bright Lights", "Loud Noise"]
    let symptoms = ["Nausea", "Sensitivity to Light", "Dizziness", "Fatigue"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Headache Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    VStack(alignment: .leading) {
                        Text("Duration (minutes)")
                        Slider(value: $duration, in: 0...1440, step: 5)
                        Text("\(Int(duration)) minutes")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Intensity")
                        Slider(value: $intensity, in: 0...10, step: 1)
                        Text("Intensity: \(Int(intensity))/10")
                    }
                }
                
                Section(header: Text("Triggers")) {
                    ForEach(triggers, id: \.self) { trigger in
                        MultipleSelectionRow(title: trigger, isSelected: selectedTriggers.contains(trigger)) {
                            if selectedTriggers.contains(trigger) {
                                selectedTriggers.removeAll { $0 == trigger }
                            } else {
                                selectedTriggers.append(trigger)
                            }
                        }
                    }
                }
                
                Section(header: Text("Symptoms")) {
                    ForEach(symptoms, id: \.self) { symptom in
                        MultipleSelectionRow(title: symptom, isSelected: selectedSymptoms.contains(symptom)) {
                            if selectedSymptoms.contains(symptom) {
                                selectedSymptoms.removeAll { $0 == symptom }
                            } else {
                                selectedSymptoms.append(symptom)
                            }
                        }
                    }
                }
                
                Button("Analyze Headache") {
                    self.likelihood = 0.75 // Placeholder for AI model prediction
                    self.showInsights = true
                }
                .sheet(isPresented: $showInsights) {
                    InsightsView(likelihood: likelihood)
                }
            }
            .navigationTitle("Log Headache")
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct HeadacheInputView_Previews: PreviewProvider {
    static var previews: some View {
        HeadacheInputView()
    }
}
