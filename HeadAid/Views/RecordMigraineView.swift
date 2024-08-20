import SwiftUI
import CoreData

struct RecordMigraineView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var currentStep = 0
    @State private var responses: [Double] = [0, 0, 0]
    @State private var additionalNotes = ""

    let questions = [
        "How intense is the headache? (0-10)",
        "What triggered the headache?",
        "What symptoms are you experiencing?"
    ]

    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<questions.count, id: \.self) { index in
                    if index == currentStep {
                        QuestionCard(
                            question: questions[index],
                            index: index,
                            total: questions.count,
                            currentStep: $currentStep,
                            responses: $responses
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        .animation(.easeInOut)
                    }
                }
            }

            if currentStep >= questions.count {
                VStack {
                    Text("Additional Notes")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    TextEditor(text: $additionalNotes)
                        .frame(height: 100)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    
                    Button(action: saveMigraineRecord) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text("Save and Back to Dashboard")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.top, 20)
                    }
                }
                .padding()
                .transition(.opacity)
                .animation(.easeInOut)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Record Migraine", displayMode: .inline)
        .navigationBarItems(
            leading: currentStep > 0 ? Button(action: {
                withAnimation {
                    currentStep -= 1
                }
            }) {
                Text("Back")
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            } : nil
        )
    }
    
    private func saveMigraineRecord() {
        let newMigraine = MigraineRecord(context: viewContext)
        newMigraine.intensity = Int16(responses[0])
        newMigraine.trigger = "Sample Trigger" // Replace with actual response
        newMigraine.symptoms = "Sample Symptoms" // Replace with actual response
        newMigraine.notes = additionalNotes
        newMigraine.date = Date()
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // Navigate back to Dashboard
        } catch {
            // Handle save error
            print("Failed to save migraine record: \(error.localizedDescription)")
        }
    }
}

struct QuestionCard: View {
    var question: String
    var index: Int
    var total: Int
    @Binding var currentStep: Int
    @Binding var responses: [Double]

    var body: some View {
        VStack(spacing: 20) {
            Text(question)
                .font(.title3)
                .fontWeight(.medium)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            
            if index == 0 {
                VStack {
                    Slider(value: Binding(
                        get: { responses[index] },
                        set: { responses[index] = $0 }
                    ), in: 0...10, step: 1)
                    .padding(.horizontal)
                    .accentColor(.green)
                    
                    Text("Intensity: \(Int(responses[index]))")
                        .foregroundColor(.green)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                if index < total - 1 {
                                    currentStep += 1
                                }
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                VStack(spacing: 10) {
                    ForEach(1..<4) { option in
                        Button(action: {
                            responses[index] = Double(option)
                            withAnimation {
                                if index < total - 1 {
                                    currentStep += 1
                                } else {
                                    // Show the additional notes section when all questions are answered
                                    withAnimation {
                                        currentStep += 1
                                    }
                                }
                            }
                        }) {
                            Text("Option \(option)")
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                    }
                }
            }
        }
        .padding(.top, 30)
    }
}


struct RecordMigraineView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMigraineView()
    }
}
