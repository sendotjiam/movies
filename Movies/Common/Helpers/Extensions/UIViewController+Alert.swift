//
//  UIViewController+Alert.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

extension UIViewController {
    func createAlert(_ title : String, _ message: String, _ handler : ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        return alert
    }
    
    func createConfirmationAlert(_ title : String, _ message: String, _ yesHandler : ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No",
                                     style: .default,
                                     handler: nil)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .destructive,
                                      handler: yesHandler)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        return alert
    }
}
