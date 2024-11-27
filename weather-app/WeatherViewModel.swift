import SwiftUI
import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    private var networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchWeatherData() {
        isLoading = true
        error = nil
        
        networkManager.fetchWeatherData()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let networkError):
                    self?.error = networkError
                    print("Error: \(networkError)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] weatherResponse in
                self?.weatherData = weatherResponse
            }
            .store(in: &cancellables)
    }
}

