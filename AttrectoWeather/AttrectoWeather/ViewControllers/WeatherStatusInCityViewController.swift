//
//  WeatherStatusInCityViewController.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 18/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import UIKit

class WeatherStatusInCityViewController: UIViewController {

	// MARK: table-view handler enum

	enum StatusDataRowType: Int {
		case humanReadableStatus
		case temperature
		case minimumTemperature
		case maximumTemperature
		case pressure
		case humidity

		static var count: Int {
			var current = 0
			while let _ = self.init(rawValue: current) { current += 1 }
			return current
		}

		var asString: String {
			switch self {
			case .humanReadableStatus: return "Státusz".localized
			case .temperature: return "Hômérséklet".localized
			case .minimumTemperature: return "Minimum hômérséklet".localized
			case .maximumTemperature: return "Maximum hômérséklet".localized
			case .pressure: return "Nyomás".localized
			case .humidity: return "Páratartalom".localized
			}
		}

		func getStringDataByType(fromWeatherStatus status: WeatherStatus) -> String {
			switch self {
			case .humanReadableStatus: return "\(status.humanReadableStatus ?? "")"
			case .temperature: return "\(status.temperature ?? 0)˚"
			case .minimumTemperature: return "\(status.minimumTemperature ?? 0)˚"
			case .maximumTemperature: return "\(status.maximumTemperature ?? 0)˚"
			case .pressure: return "\(status.pressure ?? 0) hpa"
			case .humidity: return "\(status.humidity ?? 0) %"
			}
		}
	}

	// MARK: variables

	var cityName: String?
	var weatherStatusInCity: WeatherStatus?
	@IBOutlet fileprivate var detailsTableView: UITableView!

	// MARK: life-cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupDelegates()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = cityName
	}

	// MARK: methods

	fileprivate func setupDelegates() {
		detailsTableView.dataSource = self
	}

}

// MARK: UITableViewDataSource

extension WeatherStatusInCityViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return StatusDataRowType.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

		if let rowType = StatusDataRowType.init(rawValue: indexPath.row),
		   let textLabel = cell.textLabel,
		   let weatherStatus = weatherStatusInCity {
			textLabel.text = "\(rowType.asString): \(rowType.getStringDataByType(fromWeatherStatus: weatherStatus))"
		}

		return cell
	}

}
