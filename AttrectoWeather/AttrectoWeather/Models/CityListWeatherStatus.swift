//
//  CityListWeatherStatus.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 18/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import Foundation
import ObjectMapper

struct CityListWeatherStatus: Mappable {

	fileprivate (set) var countOfFetchedCities: Int?
	fileprivate (set) var allCityStatuses: [WeatherStatus]?

	init?(map: Map) {
	}

	mutating func mapping(map: Map) {
		countOfFetchedCities <- map["cnt"]
		allCityStatuses <- map["list"]
	}

}
