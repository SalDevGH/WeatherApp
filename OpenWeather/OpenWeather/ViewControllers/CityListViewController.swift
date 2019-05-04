//
//  ViewController.swift
//  OpenWeather
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
	@IBOutlet fileprivate var backgroundView: UIView!

	fileprivate var weatherStatusForAllCities: [WeatherStatus]?
	fileprivate var usedScrollViewOffset: CGFloat = 0.0 {
		didSet {
			if usedScrollViewOffset >= 0 {
				backgroundView.backgroundColor = .white
				return
			}

			let backgroundAlpha: CGFloat = abs(usedScrollViewOffset / 1000)
			backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: backgroundAlpha)
//			print("setting ALPHA to: \(backgroundAlpha)")
		}
	}

	// MARK: life-cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "City list".localized

		setupDelegates()
		fetchWeatherStatus(ofCities: Config.CityData.idListToFetchDataFor)

		guard let navigationController = navigationController else {
			return
		}
		navigationController.navigationBar.isTranslucent = false
		if #available(iOS 11.0, *) {
			navigationController.navigationBar.prefersLargeTitles = true
//			navigationController.navigationBar.largeTitleTextAttributes = [
//			]
		}
		backgroundView.backgroundColor = .clear
	}

	// MARK: methods

	fileprivate func setupDelegates() {
		OpenWeatherMapManager.shared.delegate = self
		cityListTableView.delegate = self
		cityListTableView.dataSource = self
	}

	fileprivate func fetchWeatherStatus(ofCities cityIdList: [Int]) {
		OpenWeatherMapManager.shared.fetchWeatherStatus(
			forCityGroup: cityIdList
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
		presentErrorDialog(withTitle: "Error".localized,
						   message: "Weather data could not be received at the moment, please try again later.".localized)
	}

}

// MARK: OpenWeatherMapManagerDelegate

extension CityListViewController: OpenWeatherMapManagerDelegate {

	func weatherDataReceived(_ openWeatherMapManager: OpenWeatherMapManager, forCityGroup cityIdList: [Int]) {
		fetchWeatherStatus(ofCities: cityIdList)
	}

	func errorWhileTryingToGetWeatherData(
		_ openWeatherMapManager: OpenWeatherMapManager,
		forCityGroup cityIdList: [Int],
		error: Error?
	) {
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
			  let textLabel = cell.textLabel,
			  let detailLabel = cell.detailTextLabel else {
			return cell
		}

		textLabel.text = Config.CityData.cityNames[indexPath.row]
		detailLabel.text = Config.CityData.countyList[indexPath.row]
		cell.backgroundColor = .clear
		cell.selectionStyle = .none

		return cell
	}

}

// MARK: UITableViewDelegate

extension CityListViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 250
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let navigationController = navigationController,
			  let statusArray = weatherStatusForAllCities,
			  indexPath.row < statusArray.count,
		      indexPath.row < Config.CityData.cityNames.count else {
			presentErrorDialog(
				withTitle: "Unknown city status".localized,
				message: "No status data available for this city".localized
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

extension CityListViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		usedScrollViewOffset = scrollView.contentOffset.y
	}

}
