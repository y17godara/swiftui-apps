import SwiftUI
import Combine
import Foundation

// Define Codable structs at the top level
struct WeatherResponse: Codable {
    let hourly: HourlyWeather
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature_2m: [Double]
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
}

protocol NetworkManagerProtocol {
    func fetchWeatherData() -> AnyPublisher<WeatherResponse, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {
    private let urlString: String
    
    init(urlString: String = "https://api.open-meteo.com/v1/forecast?latitude=28.6358&longitude=77.2245&hourly=temperature_2m&daily=weather_code&timezone=IST") {
        self.urlString = urlString
    }
    
    func fetchWeatherData() -> AnyPublisher<WeatherResponse, NetworkError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        // print("Requesting data from \(url.absoluteString) : \(Date())")
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.requestFailed($0) }
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { NetworkError.decodingError($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
