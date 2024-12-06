//
//  SwiftUIView.swift
//  weather-app
//
//  Created by Yash Godara on 30/11/24.
//

import SwiftUI

struct WelcomeUIView: View {
    var body: some View {
        LoadingScreen{
            print("Get Started tapped!")
        }
    }
}

#Preview {
    WelcomeUIView()
}
