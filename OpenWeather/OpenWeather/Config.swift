//
//  Config.swift
//  OpenWeather
//
//  Created by Gabor Saliga on 17/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import Foundation

struct Config {

	static let CityData: [CityDescription] = [
		CityDescription(id: 3052009, name: "Győr".localized, countyName: "Győr-Moson-Sopron county".localized),
		CityDescription(id: 715429, name: "Szeged".localized, countyName: "Csongrád county".localized),
		CityDescription(id: 721239, name: "Eger".localized, countyName: "Heves county".localized),
		CityDescription(id: 3054638, name: "Budapest capital".localized, countyName: "Budapest county".localized),
		CityDescription(id: 3044310, name: "Szombathely".localized, countyName: "Vas county".localized)
	]

	struct OpenWeatherMapAPI {
		static let url: String = "https://api.openweathermap.org/"
		static let pathForCityGroupQuery: String = "data/2.5/group"
		static let key: String = "348b23800067dc9b8dd30a734f052ee0"
		static let units: String = "metric"
		static let language: String = "en"
		static let cacheDataUntilSeconds: TimeInterval = 600
	}

}
