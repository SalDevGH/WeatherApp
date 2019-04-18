//
//  TextualWeatherDescription.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 18/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import Foundation
import ObjectMapper

struct TextualWeatherDescription: Mappable {

	var mainDescription: String?
	var subDescription: String?

	init?(map: Map) {
	}

	mutating func mapping(map: Map) {
		mainDescription <- map["main"]
		subDescription <- map["description"]
	}

}
