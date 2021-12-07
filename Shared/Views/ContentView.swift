//
//  ContentView.swift
//  Shared
//
//  Created by Luca Kiebel on 05.12.21.
//

import SwiftUI

struct ContentView: View {
	@StateObject var locationManager = LocationManager()
	var weatherManager = WeatherManager()
	@State var weather: WeatherImageRes?
	
    var body: some View {
		VStack {
			if locationManager.location != nil {
				if let weather = weather {
					WeatherView(weather: weather)
				} else {
					LoadingView().task {
						do {
							weather = try await weatherManager.getCurrentWeatherByLocationName()
						} catch {
							print("error", error)
						}
					}
				}
			} else {
				if locationManager.isLoading {
					LoadingView()
				} else {
					WelcomeView().environmentObject(locationManager)
				}
			}
		}
		.background(Color(hue:0.656, saturation: 0.787, brightness: 0.354))
		.preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
