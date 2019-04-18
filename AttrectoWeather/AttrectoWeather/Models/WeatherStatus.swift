//
//  WeatherStatus.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 17/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import Foundation
import ObjectMapper

struct WeatherStatus: Mappable {

	var cityId: Int?
	var cityName: String?
	var humanReadableStatus: String?
	var temperature: Float?
	var pressure: Int?
	var humidity: Int?
	var minimumTemperature: Float?
	var maximumTemperature: Float?
	var textualWeatherDescriptions: [TextualWeatherDescription]?

	init?(map: Map) {
	}

	mutating func mapping(map: Map) {
		cityId <- map["id"]
		cityName <- map["name"]
		temperature <- map["main.temp"]
		pressure <- map["main.pressure"]
		humidity <- map["main.humidity"]
		minimumTemperature <- map["main.temp_min"]
		maximumTemperature <- map["main.temp_max"]
		textualWeatherDescriptions <- map["weather"]

		// creating human readable string from textualWeatherDescriptions
		var allDescriptions: [String] = []
		textualWeatherDescriptions?.forEach({ (description) in
			if let mainDescription = description.mainDescription {
				allDescriptions.append(mainDescription)
			}

			if let subDescription = description.subDescription {
				allDescriptions.append(subDescription)
			}
		})
		humanReadableStatus = allDescriptions.last
	}

}
