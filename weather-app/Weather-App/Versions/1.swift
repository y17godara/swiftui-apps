import SwiftUI
import SwiftData

struct ForecastView: View {
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

struct SwiftUIView: View {
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
    
    var body: some View {
        ZStack {
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
                
                HStack(spacing: 12) {
                    ForEach(weeklyForecast, id: \.0) { forecast in
                        ForecastView(day: forecast.0, icon: forecast.1, temp: forecast.2)
                            .onTapGesture {
                                selectedDay = forecast.0
                                selectedIcon = forecast.1
                                selectedTemp = forecast.2
                                selectedDate = forecast.4
                                checkIfToday()
                            }
                            .onAppear {
                                print("\(forecast.0) Forecast Appeared")
                            }
                    }
                }
                .padding(.horizontal)
                
                
                // News Button
                Button {
                    print("News Button Pressed")
                    // Handle news button press, e.g., navigate to a news page or fetch news
                } label: {
                    Text("Latest News")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 340, height: 10)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .foregroundStyle(.white)
        }
    }
    
    private func checkIfToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Shortened month format
        let formattedToday = formatter.string(from: todayDate)
        isToday = (formattedToday == selectedDate)
    }
    
}

#Preview {
    SwiftUIView()
}
