import SwiftUI
import SwiftData

// Extension to provide hidden functionality
extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        self.opacity(shouldHide ? 0 : 1) // Hides or shows the view based on the condition
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

// WeatherView for displaying daily forecast
struct WeatherView: View {
    let day: String
    let icon: String
    let temp: String
    
    var body: some View {
        VStack {
            Text("\(day.prefix(3))")
                .font(.headline)
            Image(systemName: icon)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text(temp)
                .font(.subheadline)
                .contentShape(Rectangle())
        }
    }
}

// Main ContentView
struct FiveView: View {
    let weeklyForecast = [
        ("Monday", "cloud.snow.fill", "-10°", "New York, NY", "Nov 25, 2024"),
        ("Tuesday", "snow", "-11°", "New York, NY", "Nov 26, 2024"),
        ("Wednesday", "cloud.snow.fill", "-12°", "New York, NY", "Nov 27, 2024"),
        ("Thursday", "cloud.snow.fill", "-17°", "New York, NY", "Nov 28, 2024"),
        ("Friday", "wind.snow", "-13°", "New York, NY", "Nov 29, 2024"),
        ("Saturday", "cloud.snow.fill", "-14°", "New York, NY", "Nov 30, 2024"),
        ("Sunday", "cloud.snow.fill", "-15°", "New York, NY", "Dec 1, 2024"),
    ]
    
    @State private var selectedDay: String = "Monday"
    @State private var selectedIcon: String = "cloud.snow.fill"
    @State private var selectedTemp: String = "-10°"
    @State private var selectedLocation: String = "New York, NY"
    @State private var selectedDate: String = "Nov 25, 2024"
    @State private var todayDate: Date = Date()
    @State private var isToday: Bool = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        ZStack(alignment: isLandscape ? .leading : .top) {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .blue.opacity(1), location: 0),   // Blue
                    .init(color: .blue.opacity(0.5), location: 0.4), // Sky Blue
                    .init(color: .blue, location: 1.0)              // White
                ]),
                startPoint: .topLeading,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .foregroundStyle(.white)
            
            // Main App Content
            ScrollView {
                if !isLandscape {
                    // Portrait view
                    VStack(alignment: .center, spacing: 60) {
                        VStack {
                            Text(selectedLocation)
                                .font(.system(size: 36, weight: .semibold))
                                .padding()
                            
                            VStack {
                                Image(systemName: selectedIcon)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180, height: 180)
                                
                                HStack {
                                    Text(selectedTemp)
                                        .font(.system(size: 80, weight: .medium))
                                    
                                    VStack (alignment: .leading, spacing: 2) {
                                        Text(isToday ? "Today" : "\(selectedDate)")
                                            .font(.system(size: 15, weight: .none))
                                        Text(selectedDay)
                                            .font(.system(size: 15, weight: .none))
                                    }
                                }
                            }
                            }
                        .padding(.bottom, 20)
                        
                        HStack(spacing: 20) {
                            ForEach(weeklyForecast, id: \.0) { forecast in
                                WeatherView(day: forecast.0, icon: forecast.1, temp: forecast.2)
                                    .onTapGesture {
                                        selectedDay = forecast.0
                                        selectedIcon = forecast.1
                                        selectedTemp = forecast.2
                                        selectedDate = forecast.4
                                        checkIfToday() // Check if the selected date is today
                                    }
                                    .onAppear {
                                        print("\(forecast.0) Forecast Appeared")
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                } else {
                    // Landscape view
                    HStack(spacing: 20) {
                        // Left Side: Weather Icon, Location, and Temperature
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("New York, NY")
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundStyle(.white)
                                Text(selectedDate)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white.opacity(0.8))
                            }

                            Image(systemName: selectedIcon)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 180, maxHeight: 180)

                            Text(selectedTemp)
                                .font(.system(size: 80, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .padding()
                        
                        // Right Side: Weekly Forecast
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(weeklyForecast, id: \.0) { forecast in
                                HStack(spacing: 10) {
                                    Text(forecast.0) // Day
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)

                                    Spacer()

                                    Image(systemName: forecast.1) // Icon
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.white)

                                    Text(forecast.2) // Temperature
                                        .font(.system(size: 18))
                                        .foregroundStyle(.white)
                                }
                                .padding(.vertical, 5)
                                .onTapGesture {
                                    // Update the selected day's details
                                    selectedDay = forecast.0
                                    selectedIcon = forecast.1
                                    selectedTemp = forecast.2
                                    selectedDate = forecast.3
                                }
                            }
                        }
                        .padding()

                    }
                }
            }
        }
        .foregroundStyle(.white)
    }
    
    // Function to check if the selected date is today's date
    private func checkIfToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Date format to match
        let formattedToday = formatter.string(from: todayDate) // Format today's date as string
        isToday = (formattedToday == selectedDate) // Compare today's date with selected date
    }
}

#Preview {
    FiveView()
}
