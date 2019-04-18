//
//  Config.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 17/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import Foundation

struct Config {

	struct CityData {
		static let idListToFetchDataFor: [Int] = [3052009, 715429, 721239, 3054638, 3044310]

		static let cityNames: [String] = [
			"Győr".localized,
			"Szeged".localized,
			"Eger".localized,
			"Budapest főváros".localized,
			"Szombathely".localized,
			"Monor".localized
		]
		static let countyList: [String] = [
			"Győr-Moson-Sopron megye".localized,
			"Csongrád megye".localized,
			"Heves megye".localized,
			"Budapest".localized,
			"Vas megye".localized,
			"Pest megye".localized
		]
	}

	struct OpenWeatherMapAPI {
		static let url: String = "https://api.openweathermap.org/"
		static let pathForCityGroupQuery: String = "data/2.5/group"
		static let key: String = "348b23800067dc9b8dd30a734f052ee0"
		static let units: String = "metric"
		static let language: String = "hu"
		static let cacheDataUntilSeconds: TimeInterval = 600
	}

}
