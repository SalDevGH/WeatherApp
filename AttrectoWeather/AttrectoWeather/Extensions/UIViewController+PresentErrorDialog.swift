//
//  UIViewController+PresentErrorDialog.swift
//  AttrectoWeather
//
//  Created by Gabor Saliga on 18/04/2019.
//  Copyright © 2019 Gabor Saliga. All rights reserved.
//

import UIKit

extension UIViewController {

	func presentErrorDialog(withTitle title: String, message: String) {
		let alertController = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert
		)
		alertController.addAction(UIAlertAction(title: "Rendben".localized, style: .cancel, handler: nil))
		present(alertController, animated: true)
	}

}
