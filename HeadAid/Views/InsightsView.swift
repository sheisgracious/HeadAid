import SwiftUI

struct InsightsView: View {
    var likelihood: Double

    var body: some View {
        VStack {
            Text("Migraine Insights")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding()

            Text("Based on your responses, the likelihood of a migraine is: \(Int(likelihood * 100))%")
                .font(.title2)
                .padding()
            
            // Add more dynamic insights or analysis here
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(likelihood: 0.75)
    }
}


