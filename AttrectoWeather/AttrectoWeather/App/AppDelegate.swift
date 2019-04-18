//
//  AppDelegate.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 17/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		OpenWeatherMapManager.shared.getCurrentWeatherStatus(forCityGroup: Config.CityData.idListToFetchDataFor)
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

}
