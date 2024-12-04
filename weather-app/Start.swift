//
//  Created by Yash Godara on 24/11/24.
//

import SwiftUI
import SwiftData

@main
struct ContentLayer: App {
    @State private var isLoading = true // State to control loading view

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingScreen()
                } else {
                    LoadingScreen()
                }
            }
            .onAppear {
                // Simulate a loading delay or fetch data
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoading = false // Stop loading after 3 seconds
                }
            }
        }
    }
}
