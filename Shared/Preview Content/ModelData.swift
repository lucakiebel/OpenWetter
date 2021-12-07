//
//  ModelData.swift
//  OpenWetter
//
//  Created by Luca Kiebel on 05.12.21.
//

import Foundation


var previewWeather: WeatherResponseBody = load("weatherData.json")

var previewWikiImage: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Muenster_Innenstadt.jpg/500px-Muenster_Innenstadt.jpg")!

func load<T: Decodable>(_ filename: String) -> T {
	let data: Data

	guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
		else {
			fatalError("Couldn't find \(filename) in main bundle.")
	}

	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}

	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}
