import SwiftUI
import SwiftData
import Foundation

struct WeatherResponse: Codable {
    let hourly: HourlyWeather
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature_2m: [Double]
}

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var errorMessage: String?
    
    func fetchWeatherData() {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=28.6358&longitude=77.2245&hourly=temperature_2m&daily=weather_code&timezone=IST"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    print("No data received")
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    print("Decoded data: \(decodedData) \n")
                    self.weatherData = decodedData
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}


struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var currentDate = Date()
    var currentTime: String {
        currentDate.formatted(.dateTime)
    }
    
    var body: some View {
        ZStack {
            Image("rain")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack() {
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    //                    Profile
                    VStack(alignment: .center, spacing: 0) {
                        Text("London")
                            .font(.system(size: 35, weight: .regular))
                            .foregroundStyle(.white.opacity(1))
                        Text("18°")
                            .font(.system(size: 110, weight: .light))
                            .foregroundStyle(.white.opacity(1))
                        
                        Text("Snow")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white.opacity(1))
                        
                        Spacer()
                        HStack {
                            Text("H:18°")
                                .font(.system(size: 18,weight: .regular))
                                .foregroundStyle(.white.opacity(1))
                            Text("L:11°")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(.white.opacity(1))
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    // Today Weather Condition
                    VStack(alignment: .leading) {
                        Text("Windy and Snowy conditions from 1Pm to 6Pm, with heavy snowfall expected in the afternoon.")
                            .font(.system(size: 16, weight: .light))
                            .foregroundStyle(.white.opacity(1))
                        Divider().background(Color.white).padding(.trailing, 16)
                        
                        // Map
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
                        
                        //                        Api
                        if let weatherData = viewModel.weatherData {
                            ForEach(weatherData.hourly.time.indices, id: \.self) { index in
                                HStack {
                                    Text(weatherData.hourly.time[index])
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text("\(Int(weatherData.hourly.temperature_2m[index]))°C")
                                        .foregroundStyle(.white)
                                }
                                Divider().background(Color.white)
                            }
                        } else {
                            Text("Loading forecast...")
                                .foregroundStyle(.white)
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
            }
            .background(.black.opacity(0.2))
        }
        .onAppear {
            viewModel.fetchWeatherData()
        }
    }
}


#Preview {
    ContentView()
}
