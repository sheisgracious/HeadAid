import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: MigraineRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MigraineRecord.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as NSDate)
    ) private var todayRecords: FetchedResults<MigraineRecord>
    
    @FetchRequest(
        entity: MigraineRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MigraineRecord.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@ AND date <= %@", Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))! as NSDate, Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!)! as NSDate)
    ) private var monthRecords: FetchedResults<MigraineRecord>

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TodayCard(records: todayRecords)
                    MonthCard(records: monthRecords)
                }
                .padding()
            }
            .navigationBarTitle("Dashboard", displayMode: .large)
        }
    }
}

struct TodayCard: View {
    var records: FetchedResults<MigraineRecord>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today")
                .font(.headline)
                .foregroundColor(.green)

            if records.isEmpty {
                Text("No headaches recorded today.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(records, id: \.self) { record in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Intensity: \(record.intensity) / 10")
                        Text("Trigger: \(record.trigger ?? "N/A")")
                        Text("Symptoms: \(record.symptoms ?? "N/A")")
                        if let notes = record.notes {
                            Text("Notes: \(notes)")
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct MonthCard: View {
    var records: FetchedResults<MigraineRecord>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Month")
                .font(.headline)
                .foregroundColor(.green)

            if records.isEmpty {
                Text("No headaches recorded this month.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                let intensityAvg = records.map { $0.intensity }.average()
                let totalRecords = records.count

                Text("Total Headaches: \(totalRecords)")
                Text("Average Intensity: \(String(format: "%.1f", intensityAvg)) / 10")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension Array where Element == Int16 {
    func average() -> Double {
        return isEmpty ? 0.0 : Double(reduce(0, +)) / Double(count)
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
