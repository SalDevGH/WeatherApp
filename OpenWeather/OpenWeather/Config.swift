//
//  Config.swift
//  OpenWeather
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
			"Budapest capital".localized,
			"Szombathely".localized
		]
		static let countyList: [String] = [
			"Győr-Moson-Sopron county".localized,
			"Csongrád county".localized,
			"Heves county".localized,
			"Budapest county".localized,
			"Vas county".localized
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
