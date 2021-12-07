//
//  WeatherManager.swift
//  OpenWetter
//
//  Created by Luca Kiebel on 05.12.21.
//

import Foundation
import CoreLocation

class WeatherManager {
	var locationManager: CLLocationManager
	
	init() {
		locationManager = CLLocationManager()
	}
	
	func getCurrentWeatherByLocationName() async throws -> WeatherImageRes{
		let location = try await self.lookUpCurrentLocation()
		
		let city = (location?.subAdministrativeArea)!
	
		guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "New%20York")&appid=3fe91049d97200b997c4c6aff68ae179&units=metric&lang=de") else {fatalError("Missing URL")}
		
		let urlRequest = URLRequest(url: url)
		
		let (data, res) = try await URLSession.shared.data(for: urlRequest)
		
		guard (res as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching weather data")}
		
		let json = try JSONDecoder().decode(WeatherResponseBody.self, from: data)
		
		let image = try await getImageForLocation()
		
		let response = WeatherImageRes(weather: json, image: image)
		
		return response
	}
	
	func lookUpCurrentLocation() async throws -> CLPlacemark? {
		// Use the last reported location.
		if let lastLocation = self.locationManager.location {
			let geocoder = CLGeocoder()
			
			let placemarks = try await geocoder.reverseGeocodeLocation(lastLocation)
			
			let firstLocation = placemarks[0]
			return firstLocation
		}
		else {
			// No location was available.
			return nil
		}
	}
	
	func getImageForLocation() async throws -> URL{
		let location = try await self.lookUpCurrentLocation()
		
		
		let city = (location?.subAdministrativeArea)!
		
		guard let wikiURL = URL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=\(city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "New%20York")&prop=pageimages&format=json&pithumbsize=500&formatversion=2") else {fatalError("Image URL Malformed")}
		
		print(wikiURL)
		
		let urlRequest = URLRequest(url: wikiURL)
		
		let (data, res) = try await URLSession.shared.data(for: urlRequest)
		
		guard (res as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error getting Wiki API")}
		
		let json = try JSONDecoder().decode(ImageResponseBody.self, from: data)
		
		return URL(string: json.query.pages[0].thumbnail.source)!
	}
}


struct ImageResponseBody: Decodable {
	var batchcomplete: Bool
	var query: QueryRes
	
	struct QueryRes:Decodable {
		var pages: [PagesRes]
	}
	
	struct PagesRes:Decodable{
		var pageid:Int
		var ns:Int
		var title:String
		var thumbnail:TNRes
		var pageimage:String
	}
	
	struct TNRes:Decodable {
		var source:String
		var width:Int
		var height:Int
		
	}
}

struct WeatherResponseBody: Decodable {
	var coord: CoordinatesResponse
	var weather: [WeatherResponse]
	var main: MainResponse
	var name: String
	var wind: WindResponse

	struct CoordinatesResponse: Decodable {
		var lon: Double
		var lat: Double
	}

	struct WeatherResponse: Decodable {
		var id: Double
		var main: String
		var description: String
		var icon: String
	}

	struct MainResponse: Decodable {
		var temp: Double
		var feels_like: Double
		var temp_min: Double
		var temp_max: Double
		var pressure: Double
		var humidity: Double
	}
	
	struct WindResponse: Decodable {
		var speed: Double
		var deg: Double
	}
}

extension WeatherResponseBody.MainResponse {
	var feelsLike: Double { return feels_like }
	var tempMin: Double { return temp_min }
	var tempMax: Double { return temp_max }
}


struct WeatherImageRes:Decodable {
	var weather:WeatherResponseBody
	var image:URL
}
