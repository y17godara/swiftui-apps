//
//  Created by Yash Godara on 24/11/24.
//

import SwiftUI
import SwiftData

enum AppStep {
    case loading
    case getStarted
    case main
}

@main
struct weather_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var isLoading = true // State to control loading view
    @State private var currentStep: AppStep = .loading // Initial step
    var body: some View {
//        WindowGroup {
            ZStack {
                switch currentStep {
                case .loading:
                   Text("Loading View")
                        .onAppear {
                            checkAppLaunchStatus()
                        }
                    
                case .getStarted:
                    LoadingScreen {
                        markGetStartedCompleted()
                        currentStep = .main
                    }

                case .main:
                    Home()
                }
            }
//        }
    }
    
    private func checkAppLaunchStatus() {
        let hasSeenGetStarted = UserDefaults.standard.bool(forKey: "HasSeenGetStarted")
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            currentStep = hasSeenGetStarted ? .main : .getStarted
        }
    }

    private func markGetStartedCompleted() {
        UserDefaults.standard.set(true, forKey: "HasSeenGetStarted")
    }
}

// Preview for the Loading Screen
struct Start_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
