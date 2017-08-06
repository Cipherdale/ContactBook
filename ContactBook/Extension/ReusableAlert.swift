//
//  ReusableAlert.swift
//  ContactBook
//
//  Created by Andrian Yohanes on 8/6/17.
//  Copyright © 2017 episquare. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func reusableAlert(alertTitle: String, alertMessage: String, viewController: UIViewController) {
        let errorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(errorAlert, animated: true, completion: nil)
    }
}
