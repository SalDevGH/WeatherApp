//
//  ViewController.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 17/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

	// MARK: constants

	struct Constants {
		static let detailsScreenStoryboardName: String = "Main"
		static let detailsScreenViewControllerName: String = "WeatherStatusInCityViewController"
	}

	// MARK: variables

	@IBOutlet fileprivate var cityListTableView: UITableView!
	fileprivate var weatherStatusForAllCities: [WeatherStatus]?

	// MARK: life-cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Városlista".localized

		setupDelegates()
		fetchWeatherStatusOfCities()
	}

	// MARK: methods

	fileprivate func setupDelegates() {
		OpenWeatherMapManager.shared.delegate = self
		cityListTableView.delegate = self
		cityListTableView.dataSource = self
	}

	fileprivate func fetchWeatherStatusOfCities() {
		OpenWeatherMapManager.shared.fetchWeatherStatus(
			forCityGroup: Config.CityData.idListToFetchDataFor
		) { [weak self] (weatherStatusForCities, error) in
			guard let strongSelf = self else {
				return
			}
			strongSelf.weatherStatusForAllCities = weatherStatusForCities

			if error != nil {
				strongSelf.presentWeatherDataFetchingFailure()
			}
		}
	}

	fileprivate func presentWeatherDataFetchingFailure() {
		presentErrorDialog(withTitle: "Hiba az adatok lekérdezése közben".localized,
						   message: "Az idôjárási adatok lekérdezés nem sikerült, kérjük próbálja késôbb".localized)
	}

}

// MARK: OpenWeatherMapManagerDelegate

extension CityListViewController: OpenWeatherMapManagerDelegate {

	func weatherDataReceived(_ openWeatherMapManager: OpenWeatherMapManager, forCityGroup cityIdList: [Int]) {
		fetchWeatherStatusOfCities()
	}

	func errorWhileTryingToGetWeatherData(_ openWeatherMapManager: OpenWeatherMapManager, forCityGroup cityIdList: [Int]) {
		presentWeatherDataFetchingFailure()
	}

}

// MARK: UITableViewDataSource

extension CityListViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Config.CityData.cityNames.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

		guard indexPath.row < Config.CityData.countyList.count,
			  indexPath.row < Config.CityData.cityNames.count,
			  let textLabel = cell.textLabel else {
			return cell
		}

		textLabel.text = Config.CityData.cityNames[indexPath.row]
		cell.detailTextLabel?.text = Config.CityData.countyList[indexPath.row]

		return cell
	}

}

// MARK: UITableViewDelegate

extension CityListViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let navigationController = navigationController,
			  let statusArray = weatherStatusForAllCities,
			  indexPath.row < statusArray.count,
		      indexPath.row < Config.CityData.cityNames.count else {
			presentErrorDialog(
				withTitle: "Ismeretlen adat a városról".localized,
				message: "Errôl a városról nem érkezett adat".localized
			)
			return
		}

		let storyBoard: UIStoryboard = UIStoryboard(name: Constants.detailsScreenStoryboardName, bundle: nil)
		if let detailsScreenViewController: WeatherStatusInCityViewController = storyBoard.instantiateViewController(
				withIdentifier: Constants.detailsScreenViewControllerName) as? WeatherStatusInCityViewController {

			detailsScreenViewController.cityName = Config.CityData.cityNames[indexPath.row]
			detailsScreenViewController.weatherStatusInCity = statusArray[indexPath.row]
			navigationController.pushViewController(detailsScreenViewController, animated: true)
		}
	}

}
