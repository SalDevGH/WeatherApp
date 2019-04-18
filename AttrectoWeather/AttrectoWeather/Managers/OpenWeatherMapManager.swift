//
//  OpenWeatherMapManager.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 17/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

// MARK: OpenWeatherMapManager delegate protocol

protocol OpenWeatherMapManagerDelegate: class {
	func weatherDataReceived(_ openWeatherMapManager: OpenWeatherMapManager, forCityGroup cityIdList: [Int])
	func errorWhileTryingToGetWeatherData(_ openWeatherMapManager: OpenWeatherMapManager, forCityGroup cityIdList: [Int])
}

// MARK: OpenWeatherMapManager

class OpenWeatherMapManager: NSObject {

	// MARK: constants

	struct Constants {
		static let urlToGetCityListWeather: String = "\(Config.OpenWeatherMapAPI.url)" +
			"\(Config.OpenWeatherMapAPI.pathForCityGroupQuery)" +
			"?lang=\(Config.OpenWeatherMapAPI.language)" +
			"&appid=\(Config.OpenWeatherMapAPI.key)&units=\(Config.OpenWeatherMapAPI.units)&id="
	}

	// MARK: weather data cache

	struct WeatherCache {
		var lastUpdatedAt: Date
		var cityIdList: [Int]
		var lastStatusForCities: [WeatherStatus]
	}

	static let shared: OpenWeatherMapManager = OpenWeatherMapManager()

	// MARK: variables

	weak var delegate: OpenWeatherMapManagerDelegate?
	var weatherCache: [WeatherCache] = []

	// MARK: life-cycle

	fileprivate override init() {
		super.init()
	}

	// MARK: methods

	public func getCurrentWeatherStatus(forCityGroup cityIdList: [Int]) -> [WeatherStatus]? {
		// trying to provide it from cache first
		if let cachedStatus = getWeatherStatusFromCache(forCityGroup: cityIdList) {
			return cachedStatus
		}

		// starting API request
		fetchWeatherStatus(forCityGroup: cityIdList)

		// no data yet
		return nil
	}

	fileprivate func fetchWeatherStatus(forCityGroup cityIdList: [Int]) {
		let cityListString: String = (cityIdList.compactMap { String($0) }).joined(separator: ",")
		let url: String = Constants.urlToGetCityListWeather + cityListString

		Alamofire.request(url).responseObject { (response: DataResponse<CityListWeatherStatus>) in
			// handle error if there were any
			if response.result.error != nil,
				let delegate = self.delegate {
				delegate.errorWhileTryingToGetWeatherData(self, forCityGroup: cityIdList)
				return
			}

			// make use of the received data
			if let cityListWeatherStatus = response.result.value,
				let lastStatusForCities = cityListWeatherStatus.allCityStatuses {
				// put data into cache
				self.weatherCache.append(
					WeatherCache(lastUpdatedAt: Date(), cityIdList: cityIdList, lastStatusForCities: lastStatusForCities)
				)

				// notify delegate
				self.delegate?.weatherDataReceived(self, forCityGroup: cityIdList)
			}
		}
	}

	fileprivate func getWeatherStatusFromCache(forCityGroup cityIdList: [Int]) -> [WeatherStatus]? {
		// drop old data first
		invalidateOutdatedCachedEntries()

		// find status in cache, if exists
		if let cachedStatus = (weatherCache.first {	$0.cityIdList == cityIdList	}) {
			return cachedStatus.lastStatusForCities
		}

		return nil
	}

	fileprivate func invalidateOutdatedCachedEntries() {
		let dateOfInvalidation: Date = Date(timeIntervalSinceNow: -Config.OpenWeatherMapAPI.cacheDataUntilSeconds)
		weatherCache = weatherCache.filter { $0.lastUpdatedAt > dateOfInvalidation }
	}

}
