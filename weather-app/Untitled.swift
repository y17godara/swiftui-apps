import SwiftUI

struct TestView: View {
    let weeklyForecast = [
        ("Monday", "cloud.snow.fill", "-10°", "Nov 25, 2024"),
        ("Tuesday", "snow", "-11°", "Nov 26, 2024"),
        ("Wednesday", "cloud.snow.fill", "-12°", "Nov 27, 2024"),
        ("Thursday", "cloud.snow.fill", "-17°", "Nov 28, 2024"),
        ("Friday", "wind.snow", "-13°", "Nov 29, 2024"),
        ("Saturday", "cloud.snow.fill", "-14°", "Nov 30, 2024"),
        ("Sunday", "cloud.snow.fill", "-15°", "Dec 1, 2024"),
    ]

    @State private var selectedDay: String = "Monday"
    @State private var selectedIcon: String = "cloud.snow.fill"
    @State private var selectedTemp: String = "-10°"
    @State private var selectedDate: String = "Nov 25, 2024"

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(1), .blue.opacity(0.5), .blue]),
                startPoint: .topLeading,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

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
            .padding()
        }
    }
}

#Preview {
    TestView()
}
