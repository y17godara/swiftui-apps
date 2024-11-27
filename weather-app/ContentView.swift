import SwiftUI
import Combine
import Foundation

struct WeatherHour {
    var time: String
    var temperature: Double
}

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var todaysWeatherData: [WeatherHour] = []
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.error {
                errorView(for: error)
            } else {
                weatherContentView
            }
        }
        .onAppear {
            print("Main View Appeared")
            viewModel.fetchWeatherData()
        }
    }
    
    private func logWeatherData() {
        if let weatherData = viewModel.weatherData {
            print("Weather Data Loaded: \(weatherData)")
        } else {
            print("Weather Data is nil or still loading.")
        }
    }
    
    private func isCurrentHour(hour: Int) -> Bool {
        let currentTime = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentTime)
        return currentHour == hour
    }
    
    private func formatHour(for num: Int) -> String {
        // Calculate hour and suffix for the given number
        let hour = num % 12
        let suffix = num < 12 ? "AM" : "PM"

        // Get the current time components
        let currentTime = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentTime)
        let currentSuffix = currentHour < 12 ? "AM" : "PM"

        // Compare the current hour and suffix with the given number
        let currentFormattedHour = currentHour % 12 == 0 ? 12 : currentHour % 12
        if currentFormattedHour == (hour == 0 ? 12 : hour) && currentSuffix == suffix {
            return "Now"
        }

        // Return the formatted hour and suffix if no match
        return "\(hour == 0 ? 12 : hour) \(suffix)"
    }

    
    private func getWeatherIcon(for temperature: Double) -> String {
        switch temperature {
        case ..<0:
            return "snowflake" // Below 0°C: Snow
        case 0..<20:
            return "cloud.sleet.fill" // 0°C to 10°C: Sleet
        case 20..<30:
            return "cloud.sun.fill" // 20°C to 30°C: Cloudy/Sunny
        default:
            return "sun.max.fill" // Above 30°C: Sunny
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(2)
    }
    
    private func errorView(for error: NetworkError) -> some View {
        VStack {
            Text("Error Occurred")
                .font(.title)
                .foregroundColor(.white)
            
            Text(errorMessage(for: error))
                .foregroundColor(.white)
                .padding()
            
            Button("Retry") {
                viewModel.fetchWeatherData()
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func errorMessage(for error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL. Please check the endpoint."
        case .requestFailed(let underlyingError):
            return "Network request failed: \(underlyingError.localizedDescription)"
        case .decodingError(let decodingError):
            return "Failed to parse weather data: \(decodingError.localizedDescription)"
        }
    }
    
    
    private var weatherContentView: some View {
        ZStack {
            Image("rain")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .background(.black.opacity(1))
            
            VStack(spacing: 10) {
                
                //                    Profile
                VStack(alignment: .center, spacing: 0) {
                    Text("London")
                        .font(.system(size: 35, weight: .regular))
                        .foregroundStyle(.white.opacity(1))
                    Text("18°")
                        .font(.system(size: 110, weight: .light))
                        .foregroundStyle(.white.opacity(1))
                    
                    VStack(spacing: 10) {
                        Text("Snow")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white.opacity(1))
                        
                        HStack {
                            Text("H:18°")
                                .font(.system(size: 18,weight: .regular))
                                .foregroundStyle(.white.opacity(1))
                            Text("L:11°")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(.white.opacity(1))
                        }
                    }
                }
                
                // Today Weather Condition
                VStack(alignment: .leading) {
                    Text("Windy and Snowy conditions from 1Pm to 6Pm, with heavy snowfall expected in the afternoon.")
                        .font(.system(size: 16, weight: .light))
                        .foregroundStyle(.white.opacity(1))
                    Divider().background(Color.white).padding(.trailing, 16)
                    
                    // Map
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let weatherData = viewModel.weatherData {
                                ForEach(weatherData.hourly.time.prefix(24).indices, id: \.self) { index in
                                    VStack(spacing: 10) {
                                        Text("\(formatHour(for: (Int(weatherData.hourly.time[index].split(separator: "T").last!.split(separator: ":").first!)!)))")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white)
                                        
                                        // Weather Icon
                                        Image(systemName: getWeatherIcon(for: weatherData.hourly.temperature_2m[index]))
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                        
                                        // Temperature
                                        Text("\(Int(weatherData.hourly.temperature_2m[index]))°")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 2)
                                    
                                }
                            } else {
                                Text("Loading forecast...")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.top,  16)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)
                .padding(.horizontal)
                .foregroundStyle(.white.opacity(0.8))
                
                
                // 10 Days Forecast
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.white.opacity(0.8))
                            .aspectRatio(contentMode: .fit)
                        Text("10-Day Forecast".uppercased(with: .autoupdatingCurrent))
                            .font(.system(size: 15, weight: .medium))
                    }
                    Divider().background(Color.white).padding(.trailing, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            if let weatherData = viewModel.weatherData {
                                ForEach(weatherData.hourly.time.indices, id: \.self) { index in
                                    HStack {
                                        Text(weatherData.hourly.time[index])
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("\(Int(weatherData.hourly.temperature_2m[index]))°C")
                                            .foregroundColor(.white)
                                    }
                                }
                            }else {
                                Text("Loading forecast...")
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    
                }
                .padding(.top,  16)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)
                .padding(.horizontal)
                .foregroundStyle(.white.opacity(0.8))
                
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 64)
            .foregroundStyle(.white.opacity(1))
            .background(.black.opacity(0.2))
            .onAppear {
                logWeatherData()
                print("Second Appear")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
