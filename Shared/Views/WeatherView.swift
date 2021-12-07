//
//  WeatherView.swift
//  OpenWetter
//
//  Created by Luca Kiebel on 05.12.21.
//

import SwiftUI

struct WeatherView: View {
	var weather: WeatherImageRes
	
    var body: some View {
		ZStack(alignment: .leading) {
			VStack {
				VStack(alignment: .leading, spacing: 5) {
					Text(weather.weather.name).bold().font(.title)
					Text("Heute, \(Date().formatted(.dateTime.month().day().hour().minute().locale(.init(identifier: "DE")))) Uhr").fontWeight(.light)
				}.frame(maxWidth:.infinity, alignment: .leading)
				
				Spacer()
				
				VStack {
					
					HStack{
						VStack(spacing:20) {
							AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.weather[0].icon)@4x.png")) { image in
									image
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 40)
								} placeholder: {
									ProgressView()
								}
							
							Text(weather.weather.weather[0].description)
						}.frame(width: 150, alignment: .leading)
						
						Spacer()
						
						Text(weather.weather.main.feelsLike.roundDouble() + "°").font(.system(size: 100))
							.fontWeight(.bold).padding()
					}
					
					Spacer().frame(height:80)
				
					AsyncImage(url: weather.image) { image in
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 350)
						} placeholder: {
							ProgressView()
						}
					
					Spacer()
					
					
					
				}.frame(maxWidth:.infinity)
				
			}.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
			
			
			VStack {
				Spacer()
				
				VStack(alignment: .leading, spacing: 20) {
					Text("Aktuelles Wetter").bold().padding(.bottom)
					
					HStack {
						WeatherRow(logo: "thermometer.snowflake", name: "Min Temp", value: (weather.weather.main.tempMin.roundDouble() + "°"))
						Spacer()
						WeatherRow(logo: "thermometer.sun", name: "Max Temp", value: (weather.weather.main.tempMax.roundDouble() + "°"))
					}
					
					HStack {
						WeatherRow(logo: "wind", name: "Windges.", value: (weather.weather.wind.speed.roundDouble() + " m/s"))
						Spacer()
						WeatherRow(logo: "humidity", name: "Luftfeuchte", value: (weather.weather.main.humidity.roundDouble() + " %"))
					}
					
					
				}.frame(maxWidth:.infinity, alignment: .leading).padding().padding(.bottom, 20)
					.foregroundColor(Color(hue:0.656, saturation: 0.787, brightness: 0.354)).background(.white)
					.cornerRadius(20, corners: [.topLeft, .topRight])
			}
			
		}.edgesIgnoringSafeArea(.bottom).background(Color(hue:0.656, saturation: 0.787, brightness: 0.354))
			.preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
		WeatherView(weather: WeatherImageRes(weather: previewWeather, image: URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Muenster_Innenstadt.jpg/500px-Muenster_Innenstadt.jpg")!))
    }
}

